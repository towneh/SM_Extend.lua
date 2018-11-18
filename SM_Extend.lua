--Warrior LUA Stuff by Towneh
--
--PART1: SPELL INTERACTION FUNCTIONS
--

function IsAlive(id)
    --Check if target is alive and ready to be interacted with
	if not id then return end
	if UnitName(id) and (not UnitIsDead(id) and UnitHealth(id)>1 and not UnitIsGhost(id) and UnitIsConnected(id)) then return true end
end

function SpellNum(spell)
	--In the wonderful world of 1.12 programming, sometimes just using a spell name isn't enough.
	--SOMETIMES you need to know what spell NUMBER it is, cause otherwise it doesn't work.
	--Healthstones and feral spells are like this.
	local i = 1 ; highestSpellNum=0
	local spellName
	while true do
		spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end
		if string.find(spellName,spell) then highestSpellNum=i end
		i = i + 1
	end
	--Fs* returned the spellid of the last spell in the spellbook if the spell is not in the spellbook
	if highestSpellNum==0 then return end
	--Fs*
	return highestSpellNum
end

function findSpell(spellName)
	local bookType=BOOKTYPE_SPELL
	local i, s;
	local found = false;
	for i = 1, MAX_SKILLLINE_TABS do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
		if (not name) then break; end
		for s = offset + 1, offset + numSpells do
			local spell, rank = GetSpellName(s, bookType);
			if (spell == spellName) then found = true; end
			if (found and spell ~=spellName) then return s-1; end
		end
	end
	if (found) then return s; end
	return nil;
end

function SpellExists(findspell)
	if not findspell then return end
	for i = 1, MAX_SKILLLINE_TABS do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
		if not name then break end
		for s = offset + 1, offset + numSpells do
		local	spell, rank = GetSpellName(s, BOOKTYPE_SPELL);
		if rank then
			local spell = spell.." "..rank;
		end
		if string.find(spell,findspell,nil,true) then
			return true
		end
		end
	end
end

function StackCast(spell,numstacks)
	--VERY useful function for stacking a certain number of debuffs (example scorch or sunder armor) on a target and then not casting anymore of that.
	local spell_icon=GetSpellTexture(SpellNum(spell),BOOKTYPE_SPELL)
	local count,icon
	for i=1,16 do
		icon,count,bufftype,duration,expiration,caster = UnitDebuff("target",i)
		if icon==spell_icon then
		    break ; end
	end
	if not count then count=0 end
	if count<numstacks then cast(spell) end
end

function OnCooldown(spell)
	--Important helper function that returns true(actually the duration left) if a spell is on cooldown, nil if not.
	if not SpellExists(spell) then return true end
	local start,duration,enable = GetSpellCooldown(SpellNum(spell),BOOKTYPE_SPELL)
	if duration==0 then
		return
	else
		return duration
	end
end

function InMeleeRange()
	--If this returns true, you can smack 'em
	return CheckInteractDistance("target",3)
end

function MyRage()
    --What's my rage?
    return UnitMana("player")
end


---PART 2: IN-COMBAT MACRO FUNCTIONS
---

function StartAttack()
    -- /Startattack functionality
    if not IsCurrentAction(60) then 
	    UseAction(60)
	end
end

function furysunder()
    --Checks target for valid boss, then applies Sunder Armor
    if (UnitLevel("target")>52 or UnitLevel("target")<0) and IsAlive("target") and UnitIsEnemy("player","target") then 
	    StackCast("Sunder Armor",5)
	end
end


function ww()
    --Casts Whirlwind, does Cleave if WW on CD
    if not OnCooldown("Whirlwind") and MyRage()>=25 then 
        CastSpellByName("Whirlwind") 
    else 
        CastSpellByName("Cleave")
    end
end

function op()
    --Casts Overpower, moves to battle stance if needed
    texture,name,isActive,isCastable=GetShapeshiftFormInfo(1)
	if not OnCooldown("Overpower") and MyRage()>=5 then
	    if not isActive and MyRage()<40 then
	        CastSpellByName("Battle Stance()")
	    else
            CastSpellByName("Overpower") 
        end
    end 
end

function bt()
    --Complicated Bloodthirst & Execute function based on target HP. Weaves in BT if player has enough AP.
    texture,name,isActive,isCastable=GetShapeshiftFormInfo(3)
	a,b,c=UnitAttackPower("player")
	AP=a+b+c
	BTDmg=AP*0.45
	if (UnitHealth('target')/UnitHealthMax('target')<0.20) then
	    if not isActive then
	        CastSpellByName("Berserker Stance()")
	    else
	        if BTDmg>=900 and not OnCooldown("Bloodthirst") then
		        CastSpellByName("Bloodthirst")
	        else
		        CastSpellByName("Execute")
		    end
	     end
    else
		if not isActive and MyRage()<30 then
	        CastSpellByName("Berserker Stance()")
	    else
	        if not OnCooldown("Bloodthirst") and MyRage()>=30 then
	            CastSpellByName("Bloodthirst")
	        end
		end
	end
end

function bsBuff()
    --Casts Battle Shout if not buffed on player. Not recommended for raids.
    local i,x=1,0 
	while UnitBuff("player",i) do 
	    if UnitBuff("player",i)=="Interface\\Icons\\Ability_Warrior_BattleShout" then 
		    x=1 
		end 
		i=i+1 
    end 
	if x==0 then 
		CastSpellByName("Battle Shout")
	end
end