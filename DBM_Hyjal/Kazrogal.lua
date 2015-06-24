local Kazrogal = DBM:NewBossMod("Kazrogal", DBM_KAZROGAL_NAME, DBM_KAZROGAL_DESCRIPTION, DBM_MOUNT_HYJAL, DBM_HYJAL_TAB, 3);

Kazrogal.Version	= "1.1";
Kazrogal.Author		= "LYQ";

local counter = 0;
local marks = {41,36,32,27,22,19,13,10,10,5,6,9,10,11,9,11}

Kazrogal:RegisterCombat("YELL", DBM_KAZROGAL_YELL_PULL, nil, nil, nil, 100);

Kazrogal:AddBarOption("War Stomp")
Kazrogal:AddBarOption("Next Mark")

Kazrogal:RegisterEvents(
	"SPELL_AURA_APPLIED",
    "SPELL_CAST_START"
);

function Kazrogal:OnCombatStart()
	counter = 0;
    self:EndStatusBarTimer("Next Wave")
    self:StartStatusBarTimer(14.5, "War Stomp", "Interface\\Icons\\Ability_Warstomp");
    self:ScheduleSelf(14.5, "Stun")
    self:StartStatusBarTimer(45, "Next Mark", "Interface\\Icons\\Spell_Shadow_Soulleech_3");
end

function Kazrogal:OnEvent(event, args)
	if event == "SPELL_AURA_APPLIED" then
		if args.spellId == 31447 then
			self:SendSync("Debuff")
        elseif args.spellId == 31480 then
            -- probably won't do shit
            self:SendSync("Stun")
		end
    elseif event == "SPELL_CAST_START" then
        if args.spellId == 31480 then
            self:SendSync("Stun")
		end
    elseif event == "Stun" then
        -- LYQ: in case we don't trigger the spell cast
        self:StartStatusBarTimer(20, "War Stomp", "Interface\\Icons\\Ability_Warstomp");
        self:UnScheduleSelf("Stun")
        self:ScheduleSelf(20, "Stun")
	end
end

function Kazrogal:OnSync(msg)
	if msg == "Debuff" then
		counter = counter + 1;
		self:Announce(DBM_KAZROGAL_WARN_MARK:format(counter), 2);
        if marks[counter] then
            self:StartStatusBarTimer(marks[counter], "Next Mark", "Interface\\Icons\\Spell_Shadow_Soulleech_3");
        else
            self:StartStatusBarTimer(10, "Next Mark", "Interface\\Icons\\Spell_Shadow_Soulleech_3");
        end
    elseif msg == "Stun" then
        self:StartStatusBarTimer(20, "War Stomp", "Interface\\Icons\\Ability_Warstomp");
        self:UnScheduleSelf("Stun")
        self:ScheduleSelf(20, "Stun") -- let's schedule it again in case the next stun will not get triggered cus nobody got hit by it - is that possible?
	end
end