# SM_Extend.lua
My customised SM_Extend.lua file containing Fury Warrior functionality for SuperMacro (1.12.1 supported versions only)

## Usage:

### Installation
This file should be placed within the World of Warcraft\Interface\AddOns\SuperMacro directory.

### Macro Example
In order to use the functions contained in the LUA file, you need to crete a macro similar to those below.

The initial /run line is included so that SuperMacro provides the correct cooldown icon for the desired spell.

```
MACRO 16777249 "BT" Spell_Nature_BloodLust
/run if 1==0 then cast("Bloodthirst");end
/script StartAttack()
/script furysunder()
/script bt()
```

```
MACRO 16777233 "OP" Ability_MeleeDamage
/run if 1==0 then cast("Overpower");end
/script StartAttack()
/script op()
```
