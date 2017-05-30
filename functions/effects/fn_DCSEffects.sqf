params ["_DCSAffDiverDam"];

_DCSRunTimes = _DCSRunTimes + 1;
_DCSColor = ppEffectCreate ["colorCorrections", 1001];
_DCSBlur = ppEffectCreate ["radialBlur", 1002];
_DCSDynBlur = ppEffectCreate ["DynamicBlur", 1003];
_DCSChroma = ppEffectCreate ["chromAberration", 1004];
titleText ["","BLACK OUT",1];
[{
	params ["_DCSColor", "_DCSBlur", "_DCSDynBlur", "_DCSChroma"];
	titleText ["","BLACK IN",1];
	_DCSColor ppEffectEnable true;
	_DCSColor ppEffectAdjust [1, 1, 0, [1.0,0.0,0.0,0.2], [0,1,0,0.5], [0,0,0,0]]; 
	_DCSColor ppEffectCommit 1;
	_DCSBlur ppEffectEnable true;
	_DCSBlur ppEffectAdjust [0.001,0.001,0.15,0.15];
	_DCSDynBlur ppEffectEnable true;
	_DCSDynBlur ppEffectAdjust [0.5];
	_DCSChroma ppEffectEnable true;
	_DCSChroma ppEffectAdjust [0.09,0.09,true];
	_DCSChroma ppEffectCommit 1;
	_DCSBlur ppEffectCommit 1;
	_DCSDynBlur ppEffectCommit 1;
	_damageVar = player getvariable ["ace_medical_bodyPartStatus", [0,0,0,0,0,0]]; 
	_bodyPart = selectRandom ["head", "body", "arm_r", "arm_l", "leg_r", "leg_l"];
	[player, _bodyPart, (_damageVar select ([_bodyPart] call ace_medical_fnc_selectionNameToNumber)) + _DCSAffDiverDam, player, "explosive", -1] call ace_medical_fnc_handleDamage;
	[{
		titleText ["","BLACK OUT",1];
		[{
			params ["_DCSColor", "_DCSBlur", "_DCSDynBlur", "_DCSChroma"];
			titleText ["","BLACK IN",1];
			ppEffectDestroy _DCSBlur;
			ppEffectDestroy _DCSDynBlur;
			ppEffectDestroy _DCSChroma;
			ppEffectDestroy _DCSColor;	
		}, _this, 1] call CBA_fnc_waitAndExecute;            
	}, _this, 1] call CBA_fnc_waitAndExecute;        
}, [_DCSColor, _DCSBlur, _DCSDynBlur, _DCSChroma], 1] call CBA_fnc_waitAndExecute;
