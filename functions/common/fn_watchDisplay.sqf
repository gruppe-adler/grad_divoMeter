[{
	params ["_args","_handle"];
	if !(EDOPEN) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};
	
	if (((eyePos player select 2) < 0) && EDGEARON) then {
		disableSerialization;
		_displayUI = uiNamespace getVariable "slb_display";
			
		if (EDMETRIC) then {
			(_displayUI displayCtrl 1111) ctrlSetText "M";
			(_displayUI displayCtrl 1113) ctrlSetText format["%1",(round(grad_depth *10))/10];
			(_displayUI displayCtrl 1120) ctrlSetText "BAR";
			(_displayUI displayCtrl 1122) ctrlSetText format["%1", round (grad_filling)];
		}else {
			(_displayUI displayCtrl 1111) ctrlSetText "FT";
			(_displayUI displayCtrl 1113) ctrlSetText format["%1",((round((grad_depth * 3.28) *10))/10)];
			(_displayUI displayCtrl 1120) ctrlSetText "PSI";
			(_displayUI displayCtrl 1122) ctrlSetText format["%1", grad_filling];
		};
			
		if (grad_doDeco) then {
			(_displayUI displayCtrl 1112) ctrlSetText "DECO";
			if (!(grad_depth2deco > 3) && !(grad_depth2deco < -3)) then {
				(_displayUI displayCtrl 1120) ctrlSetText format["%1", grad_decoTime];
			};
		}else{
			(_displayUI displayCtrl 1112) ctrlSetText "NO DECO";
		};
			
		(_displayUI displayCtrl 1121) ctrlSetText "GTK";
		(_displayUI displayCtrl 1114) ctrlSetText format["%1", round (((grad_timeleft) + .01)/60)];
		(_displayUI displayCtrl 1119) ctrlSetText format["%1", (round (grad_percentO2 * 100))/100];
		
		switch (true) do {
			case (!grad_doDeco): {
				(_displayUI displayCtrl 1125) ctrlSetText "";
				(_displayUI displayCtrl 1126) ctrlSetText "";
				(_displayUI displayCtrl 1127) ctrlSetText "";
				(_displayUI displayCtrl 1130) ctrlSetText "";
				(_displayUI displayCtrl 1131) ctrlSetText "";
				(_displayUI displayCtrl 1115) ctrlSetText "TTS";
				(_displayUI displayCtrl 1116) ctrlSetText "DIVE-T";
				(_displayUI displayCtrl 1117) ctrlSetText format["%1", round (grad_ascTime)];
				(_displayUI displayCtrl 1118) ctrlSetText format["%1", round (((grad_diveTime)+.01)/60)];
			};
			case (grad_doDeco && !(grad_depth2deco < - 6) && !(grad_depth2deco > 6)): {
				(_displayUI displayCtrl 1115) ctrlSetText "";
					(_displayUI displayCtrl 1116) ctrlSetText "";
				(_displayUI displayCtrl 1117) ctrlSetText "";
				(_displayUI displayCtrl 1118) ctrlSetText "";
				(_displayUI displayCtrl 1125) ctrlSetText "DECO STOP";
				(_displayUI displayCtrl 1126) ctrlSetText format ["%1M", grad_depth2deco];
				(_displayUI displayCtrl 1127) ctrlSetText format ["%1", grad_deepStopTime];
				(_displayUI displayCtrl 1130) ctrlSetText "grad_enhancedDiving\images\triangle_down_divider.paa";
				(_displayUI displayCtrl 1131) ctrlSetText "grad_enhancedDiving\images\triangle_up_divider.paa";
			};
			case (grad_doDeepStop && !(grad_depth2deepStop < - 6) && !(grad_depth2deepStop > 6)): {
				(_displayUI displayCtrl 1124) ctrlSetText "";
				(_displayUI displayCtrl 1125) ctrlSetText "DEEP STOP";
				(_displayUI displayCtrl 1126) ctrlSetText format ["%1M", grad_depth2deepStop];
				(_displayUI displayCtrl 1127) ctrlSetText format ["%1", grad_deepStopTime];
				
				switch (true) do {
					case (grad_depth2deepStop > 1.5) : {
						if ((ctrlText 1131) == "grad_enhancedDiving\images\triangle_down_divider.paa") then {
							(_displayUI displayCtrl 1130) ctrlSetText "";
							(_displayUI displayCtrl 1131) ctrlSetText "";
						}else{
							(_displayUI displayCtrl 1130) ctrlSetText "";
							(_displayUI displayCtrl 1131) ctrlSetText "grad_enhancedDiving\images\triangle_down_divider.paa";
						};
					};
					case (grad_depth2deepStop < -1.5) : {
						if ((ctrlText 1131) == "grad_enhancedDiving\images\triangle_up_divider.paa") then {
							(_displayUI displayCtrl 1130) ctrlSetText "";
							(_displayUI displayCtrl 1131) ctrlSetText "";
						}else{
							(_displayUI displayCtrl 1130) ctrlSetText "grad_enhancedDiving\images\triangle_up_divider.paa";
							(_displayUI displayCtrl 1131) ctrlSetText "";
						};
					};
					case (grad_depth2deepStop < 1.5 && grad_depth2deepStop > -1.5) : {
						(_displayUI displayCtrl 1130) ctrlSetText "grad_enhancedDiving\images\triangle_up_divider.paa";
						(_displayUI displayCtrl 1131) ctrlSetText "grad_enhancedDiving\images\triangle_down_divider.paa";
					};
				};
			};
		};
			
		if (grad_upDepth <= 0.3) then {
				(_displayUI displayCtrl 1128) ctrlSetText "";
		}else{
			if (grad_upDepth >= 9) then {
				if ((ctrlText 1128) == "grad_enhancedDiving\images\left_06.paa")then {
					(_displayUI displayCtrl 1128) ctrlSetText "";
				}else{
					(_displayUI displayCtrl 1128) ctrlSetText "grad_enhancedDiving\images\left_06.paa";
				};
			}else{
				_getenhancedDivingRiseTexture = {
					_riseIndex = { 
						if (_this < _x)  exitWith{_forEachIndex};
					}forEach [1.5, 3, 4.6, 6.1, 7.6, 9];   
					format[ "grad_enhancedDiving\images\left_0%1.paa", _riseIndex]; 
				}; 
				(_displayUI displayCtrl 1128) ctrlSetText (grad_upDepth call _getenhancedDivingRiseTexture);
			};
		};
			
		if (grad_narcFactor >= 9.1) then {
				if ((ctrlText 1129) == "grad_enhancedDiving\images\right_09.paa")then {
					(_displayUI displayCtrl 1129) ctrlSetText "";
				}else{
					(_displayUI displayCtrl 1129) ctrlSetText "grad_enhancedDiving\images\right_09.paa";
				};
			}else {
				_getenhancedDivingN2Texture = {
					_n2Index = { 
						if (_this < _x)  exitWith{_forEachIndex};
					}forEach [1, 2, 3, 4, 5, 6, 7, 8, 9]; 
					diag_log format[ "grad_enhancedDiving\images\right_0%1.paa", _n2Index]; 
					format[ "grad_enhancedDiving\images\right_0%1.paa", _n2Index]; 
				}; 
			(_displayUI displayCtrl 1129) ctrlSetText (grad_narcFactor call _getenhancedDivingN2Texture);
		};
		(_displayUI displayCtrl 1132) ctrlSetText format ["%1", grad_selectedTank];
	}else{
			
		disableSerialization;
		_displayUI = uiNamespace getVariable "slb_display";
		if (EDMETRIC) then {
			(_displayUI displayCtrl 1111) ctrlSetText "M";
			(_displayUI displayCtrl 1120) ctrlSetText "BAR";
			(_displayUI displayCtrl 1113) ctrlSetText format["%1",(round(((getPosASL player) select 2) *10))/10];
		}else{
			(_displayUI displayCtrl 1111) ctrlSetText "FT";
			(_displayUI displayCtrl 1120) ctrlSetText "PSI";
			(_displayUI displayCtrl 1113) ctrlSetText format["%1",(round((((getPosASL player) select 2)*3.28) *10))/10];
		};
		
		(_displayUI displayCtrl 1112) ctrlSetText "NO DECO";
		(_displayUI displayCtrl 1114) ctrlSetText "--";
		(_displayUI displayCtrl 1115) ctrlSetText "TTS";
		(_displayUI displayCtrl 1116) ctrlSetText "DIVE-T";
		(_displayUI displayCtrl 1117) ctrlSetText "--";
		(_displayUI displayCtrl 1118) ctrlSetText "--";
		(_displayUI displayCtrl 1119) ctrlSetText "";
		(_displayUI displayCtrl 1121) ctrlSetText "GTK";
		(_displayUI displayCtrl 1122) ctrlSetText "---";
		(_displayUI displayCtrl 1123) ctrlSetText "--";
		(_displayUI displayCtrl 1132) ctrlSetText format ["%1", grad_selectedTank];
	};
}, 1, []] call CBA_fnc_addPerFrameHandler;