local Anetheron = DBM:NewBossMod("Anetheron", DBM_ANETHERON_NAME, DBM_ANETHERON_DESCRIPTION, DBM_MOUNT_HYJAL, DBM_HYJAL_TAB, 2);

Anetheron.Version	= "1.1";
Anetheron.Author	= "LYQ";

local lastTarget;

--Anetheron:RegisterCombat("YELL", DBM_ANETHERON_YELL_PULL, nil, nil, nil, 60);
Anetheron:RegisterCombat("COMBAT", 5, DBM_ANETHERON_NAME)

Anetheron:AddOption("WarnCarrion", true, DBM_ANEETHERON_OPTION_CARRION);
Anetheron:AddOption("WarnInferno", true, DBM_ANEETHERON_OPTION_INFERNAL);

Anetheron:AddBarOption("Infernal")
Anetheron:AddBarOption("Carrion Swarm")

Anetheron:RegisterEvents(
	"SPELL_AURA_APPLIED"
);

function Anetheron:OnCombatStart(delay)
    self:EndStatusBarTimer("Next Wave")
    self:StartStatusBarTimer(15 - delay, "Carrion Swarm", "Interface\\Icons\\Spell_Shadow_CarrionSwarm");
end

function Anetheron:OnEvent(event, arg1)
	if event == "SPELL_AURA_APPLIED" then
		if arg1.spellId == 31306 then
			self:SendSync("CarrionSwarm");
		end
	elseif event == "InfernoWarn" then
		self:Announce(DBM_ANETHERON_WARN_INFERNO_SOON, 2);
	elseif event == "CheckSpell" and arg1 then
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid"..i.."target") == DBM_ANETHERON_NAME then
				if UnitCastingInfo("raid"..i.."target") == DBM_ANETHERON_INFERNO then
					self:SendSync("Inferno"..arg1);
				end
				break;
			end
		end
	end
end

function Anetheron:OnSync(msg)
	if msg == "CarrionSwarm" then
		if self.Options.WarnCarrion then
			self:Announce(DBM_ANETHERON_WARN_CARRION, 1);
		end
		self:StartStatusBarTimer(18, "Carrion Swarm", "Interface\\Icons\\Spell_Shadow_CarrionSwarm");
		
	elseif msg:sub(0, 7) == "Inferno" then
		local target = msg:sub(8);
		if target == "" then
			for i = 1, GetNumRaidMembers() do
				if UnitName("raid"..i.."target") == DBM_ANETHERON_NAME then
					target = UnitName("raid"..i.."targettarget")
				end
			end
			if not target then
				target = DBM.Capitalize(DBM_UNKNOWN);
			end
		end

		if self.Options.WarnInferno then
			self:Announce(DBM_ANETHERON_WARN_INFERNO:format(target), 3);
			self:ScheduleSelf(60, "InfernoWarn");
		end
		self:StartStatusBarTimer(64, "Infernal", "Interface\\Icons\\Spell_Shadow_SummonInfernal");
	end
end

function Anetheron:OnUpdate(elapsed)
	for i = 1, GetNumRaidMembers() do
		if UnitName("raid"..i.."target") == DBM_ANETHERON_NAME then
			if UnitName("raid"..i.."targettarget") ~= lastTarget then
				lastTarget = UnitName("raid"..i.."targettarget");
				if UnitCastingInfo("raid"..i.."target") == DBM_ANETHERON_INFERNO then
					self:SendSync("Inferno"..(lastTarget or DBM_UNKNOWN));
				else
					self:ScheduleSelf(0.5, "CheckSpell", lastTarget);
				end
				break;
			end
		end
	end
end