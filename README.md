# SM_Extend.lua
My customised SM_Extend.lua file for SuperMacro functions

## Usage:

Macro Example -

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
