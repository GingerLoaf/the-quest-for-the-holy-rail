//Maya ASCII 2023 scene
//Name: Sid_Parry.ma
//Last modified: Mon, Jan 26, 2026 10:37:27 PM
//Codeset: 1252
file -rdi 1 -ns "Sid_Rig" -rfn "Sid_RigRN" -op "v=0;" -typ "mayaAscii" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Sid_Rig.ma";
file -r -ns "Sid_Rig" -dr 1 -rfn "Sid_RigRN" -op "v=0;" -typ "mayaAscii" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Sid_Rig.ma";
requires maya "2023";
requires "stereoCamera" "10.0";
requires -nodeType "gameFbxExporter" "gameFbxExporter" "1.0";
requires "mtoa" "5.1.0";
requires -nodeType "ilrOptionsNode" -nodeType "ilrUIOptionsNode" -nodeType "ilrBakeLayerManager"
		 -nodeType "ilrBakeLayer" "Turtle" "2023.0.0";
requires "maxwell" "1.0.16";
currentUnit -l centimeter -a degree -t ntsc;
fileInfo "application" "maya";
fileInfo "product" "Maya 2023";
fileInfo "version" "2023";
fileInfo "cutIdentifier" "202202161415-df43006fd3";
fileInfo "osv" "Windows 11 Pro v2009 (Build: 26200)";
fileInfo "UUID" "99B8198F-46EB-8981-6F94-19A684BB4AAF";
createNode transform -s -n "persp";
	rename -uid "499C4AE0-4E6A-8F18-FA1B-0F95C87BEDF0";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 1.1566231647153149 44.869038805910492 -120.40607434685369 ;
	setAttr ".r" -type "double3" -14.138352730101298 534.19999999979507 0 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "67043205-4C8E-787C-947F-0B8E5AF42A2E";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 123.98310032517273;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	rename -uid "8EA86AC8-4B75-A8FB-21E2-5CA26B56EBCB";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 1000.1 0 ;
	setAttr ".r" -type "double3" -90 0 0 ;
createNode camera -s -n "topShape" -p "top";
	rename -uid "1B96104B-4897-9B0D-27E1-FAB8BBF26A54";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 1000.1;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "top";
	setAttr ".den" -type "string" "top_depth";
	setAttr ".man" -type "string" "top_mask";
	setAttr ".hc" -type "string" "viewSet -t %camera";
	setAttr ".o" yes;
	setAttr ".ai_translator" -type "string" "orthographic";
createNode transform -s -n "front";
	rename -uid "ED8D969E-4CFA-6D15-7CC0-AAA3A7EF5532";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 0 1000.1 ;
createNode camera -s -n "frontShape" -p "front";
	rename -uid "0FA1D97D-4A47-DD4F-DE62-6E9FE10FE475";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 1000.1;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "front";
	setAttr ".den" -type "string" "front_depth";
	setAttr ".man" -type "string" "front_mask";
	setAttr ".hc" -type "string" "viewSet -f %camera";
	setAttr ".o" yes;
	setAttr ".ai_translator" -type "string" "orthographic";
createNode transform -s -n "side";
	rename -uid "C7E921EB-400E-5DA9-1514-A98F6C653956";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 1000.1 0 0 ;
	setAttr ".r" -type "double3" 0 90 0 ;
createNode camera -s -n "sideShape" -p "side";
	rename -uid "3C1F6879-45B0-8786-AD5A-2CBFA172BFCA";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 1000.1;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "side";
	setAttr ".den" -type "string" "side_depth";
	setAttr ".man" -type "string" "side_mask";
	setAttr ".hc" -type "string" "viewSet -s %camera";
	setAttr ".o" yes;
	setAttr ".ai_translator" -type "string" "orthographic";
createNode lightLinker -s -n "lightLinker1";
	rename -uid "CFC3C1AB-454B-35D3-20D4-1B90651CA750";
	setAttr -s 23 ".lnk";
	setAttr -s 23 ".slnk";
createNode shapeEditorManager -n "shapeEditorManager";
	rename -uid "F5ACA3A4-4E16-0A67-7121-59A2935C94F6";
createNode poseInterpolatorManager -n "poseInterpolatorManager";
	rename -uid "ED77211C-496E-2EAA-73D8-8789D51AA19F";
createNode displayLayerManager -n "layerManager";
	rename -uid "BEC99B28-4567-52D9-190E-E6819FC1E6FB";
createNode displayLayer -n "defaultLayer";
	rename -uid "45BEDA75-45D9-CE1B-09E6-50A07C8A63D7";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "CE5916B7-420A-4A8F-A63F-7B8BF87F4C37";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "F14B7E69-4562-804A-3BA9-72AE642E9E1E";
	setAttr ".g" yes;
createNode gameFbxExporter -n "gameExporterPreset1";
	rename -uid "A0DE2A0E-4DBB-318D-EA5D-73A108E832A8";
	setAttr ".pn" -type "string" "Model Default";
	setAttr ".ils" yes;
	setAttr ".ssn" -type "string" "";
	setAttr ".ebm" yes;
	setAttr ".ich" yes;
	setAttr ".inc" yes;
	setAttr ".fv" -type "string" "FBX201800";
	setAttr ".exp" -type "string" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Export";
	setAttr ".exf" -type "string" "Sid_Parry";
createNode gameFbxExporter -n "gameExporterPreset2";
	rename -uid "92ED7AE6-40CC-D470-EBDB-088A69B6323E";
	setAttr ".pn" -type "string" "Anim Default";
	setAttr ".ils" yes;
	setAttr ".ilu" yes;
	setAttr ".eti" 2;
	setAttr ".esi" 2;
	setAttr ".ssn" -type "string" "";
	setAttr ".ac[0].acn" -type "string" "Parry";
	setAttr ".ac[0].acs" 1;
	setAttr ".ac[0].ace" 26;
	setAttr ".spt" 2;
	setAttr ".ic" no;
	setAttr ".ebm" yes;
	setAttr ".fv" -type "string" "FBX201800";
	setAttr ".exp" -type "string" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Export";
createNode gameFbxExporter -n "gameExporterPreset3";
	rename -uid "41EF615B-4A74-0D4C-D2D0-E49A70FCB9B2";
	setAttr ".pn" -type "string" "TE Anim Default";
	setAttr ".ils" yes;
	setAttr ".eti" 3;
	setAttr ".ebm" yes;
	setAttr ".fv" -type "string" "FBX201800";
createNode reference -n "Sid_RigRN";
	rename -uid "8805E5D4-43BC-B77F-3B2B-58B5EC262252";
	setAttr -s 423 ".phl";
	setAttr ".phl[1]" 0;
	setAttr ".phl[2]" 0;
	setAttr ".phl[3]" 0;
	setAttr ".phl[4]" 0;
	setAttr ".phl[5]" 0;
	setAttr ".phl[6]" 0;
	setAttr ".phl[7]" 0;
	setAttr ".phl[8]" 0;
	setAttr ".phl[9]" 0;
	setAttr ".phl[10]" 0;
	setAttr ".phl[11]" 0;
	setAttr ".phl[12]" 0;
	setAttr ".phl[13]" 0;
	setAttr ".phl[14]" 0;
	setAttr ".phl[15]" 0;
	setAttr ".phl[16]" 0;
	setAttr ".phl[17]" 0;
	setAttr ".phl[18]" 0;
	setAttr ".phl[19]" 0;
	setAttr ".phl[20]" 0;
	setAttr ".phl[21]" 0;
	setAttr ".phl[22]" 0;
	setAttr ".phl[23]" 0;
	setAttr ".phl[24]" 0;
	setAttr ".phl[25]" 0;
	setAttr ".phl[26]" 0;
	setAttr ".phl[27]" 0;
	setAttr ".phl[28]" 0;
	setAttr ".phl[29]" 0;
	setAttr ".phl[30]" 0;
	setAttr ".phl[31]" 0;
	setAttr ".phl[32]" 0;
	setAttr ".phl[33]" 0;
	setAttr ".phl[34]" 0;
	setAttr ".phl[35]" 0;
	setAttr ".phl[36]" 0;
	setAttr ".phl[37]" 0;
	setAttr ".phl[38]" 0;
	setAttr ".phl[39]" 0;
	setAttr ".phl[40]" 0;
	setAttr ".phl[41]" 0;
	setAttr ".phl[42]" 0;
	setAttr ".phl[43]" 0;
	setAttr ".phl[44]" 0;
	setAttr ".phl[45]" 0;
	setAttr ".phl[46]" 0;
	setAttr ".phl[47]" 0;
	setAttr ".phl[48]" 0;
	setAttr ".phl[49]" 0;
	setAttr ".phl[50]" 0;
	setAttr ".phl[51]" 0;
	setAttr ".phl[52]" 0;
	setAttr ".phl[53]" 0;
	setAttr ".phl[54]" 0;
	setAttr ".phl[55]" 0;
	setAttr ".phl[56]" 0;
	setAttr ".phl[57]" 0;
	setAttr ".phl[58]" 0;
	setAttr ".phl[59]" 0;
	setAttr ".phl[60]" 0;
	setAttr ".phl[61]" 0;
	setAttr ".phl[62]" 0;
	setAttr ".phl[63]" 0;
	setAttr ".phl[64]" 0;
	setAttr ".phl[65]" 0;
	setAttr ".phl[66]" 0;
	setAttr ".phl[67]" 0;
	setAttr ".phl[68]" 0;
	setAttr ".phl[69]" 0;
	setAttr ".phl[70]" 0;
	setAttr ".phl[71]" 0;
	setAttr ".phl[72]" 0;
	setAttr ".phl[73]" 0;
	setAttr ".phl[74]" 0;
	setAttr ".phl[75]" 0;
	setAttr ".phl[76]" 0;
	setAttr ".phl[77]" 0;
	setAttr ".phl[78]" 0;
	setAttr ".phl[79]" 0;
	setAttr ".phl[80]" 0;
	setAttr ".phl[81]" 0;
	setAttr ".phl[82]" 0;
	setAttr ".phl[83]" 0;
	setAttr ".phl[84]" 0;
	setAttr ".phl[85]" 0;
	setAttr ".phl[86]" 0;
	setAttr ".phl[87]" 0;
	setAttr ".phl[88]" 0;
	setAttr ".phl[89]" 0;
	setAttr ".phl[90]" 0;
	setAttr ".phl[91]" 0;
	setAttr ".phl[92]" 0;
	setAttr ".phl[93]" 0;
	setAttr ".phl[94]" 0;
	setAttr ".phl[95]" 0;
	setAttr ".phl[96]" 0;
	setAttr ".phl[97]" 0;
	setAttr ".phl[98]" 0;
	setAttr ".phl[99]" 0;
	setAttr ".phl[100]" 0;
	setAttr ".phl[101]" 0;
	setAttr ".phl[102]" 0;
	setAttr ".phl[103]" 0;
	setAttr ".phl[104]" 0;
	setAttr ".phl[105]" 0;
	setAttr ".phl[106]" 0;
	setAttr ".phl[107]" 0;
	setAttr ".phl[108]" 0;
	setAttr ".phl[109]" 0;
	setAttr ".phl[110]" 0;
	setAttr ".phl[111]" 0;
	setAttr ".phl[112]" 0;
	setAttr ".phl[113]" 0;
	setAttr ".phl[114]" 0;
	setAttr ".phl[115]" 0;
	setAttr ".phl[116]" 0;
	setAttr ".phl[117]" 0;
	setAttr ".phl[118]" 0;
	setAttr ".phl[119]" 0;
	setAttr ".phl[120]" 0;
	setAttr ".phl[121]" 0;
	setAttr ".phl[122]" 0;
	setAttr ".phl[123]" 0;
	setAttr ".phl[124]" 0;
	setAttr ".phl[125]" 0;
	setAttr ".phl[126]" 0;
	setAttr ".phl[127]" 0;
	setAttr ".phl[128]" 0;
	setAttr ".phl[129]" 0;
	setAttr ".phl[130]" 0;
	setAttr ".phl[131]" 0;
	setAttr ".phl[132]" 0;
	setAttr ".phl[133]" 0;
	setAttr ".phl[134]" 0;
	setAttr ".phl[135]" 0;
	setAttr ".phl[136]" 0;
	setAttr ".phl[137]" 0;
	setAttr ".phl[138]" 0;
	setAttr ".phl[139]" 0;
	setAttr ".phl[140]" 0;
	setAttr ".phl[141]" 0;
	setAttr ".phl[142]" 0;
	setAttr ".phl[143]" 0;
	setAttr ".phl[144]" 0;
	setAttr ".phl[145]" 0;
	setAttr ".phl[146]" 0;
	setAttr ".phl[147]" 0;
	setAttr ".phl[148]" 0;
	setAttr ".phl[149]" 0;
	setAttr ".phl[150]" 0;
	setAttr ".phl[151]" 0;
	setAttr ".phl[152]" 0;
	setAttr ".phl[153]" 0;
	setAttr ".phl[154]" 0;
	setAttr ".phl[155]" 0;
	setAttr ".phl[156]" 0;
	setAttr ".phl[157]" 0;
	setAttr ".phl[158]" 0;
	setAttr ".phl[159]" 0;
	setAttr ".phl[160]" 0;
	setAttr ".phl[161]" 0;
	setAttr ".phl[162]" 0;
	setAttr ".phl[163]" 0;
	setAttr ".phl[164]" 0;
	setAttr ".phl[165]" 0;
	setAttr ".phl[166]" 0;
	setAttr ".phl[167]" 0;
	setAttr ".phl[168]" 0;
	setAttr ".phl[169]" 0;
	setAttr ".phl[170]" 0;
	setAttr ".phl[171]" 0;
	setAttr ".phl[172]" 0;
	setAttr ".phl[173]" 0;
	setAttr ".phl[174]" 0;
	setAttr ".phl[175]" 0;
	setAttr ".phl[176]" 0;
	setAttr ".phl[177]" 0;
	setAttr ".phl[178]" 0;
	setAttr ".phl[179]" 0;
	setAttr ".phl[180]" 0;
	setAttr ".phl[181]" 0;
	setAttr ".phl[182]" 0;
	setAttr ".phl[183]" 0;
	setAttr ".phl[184]" 0;
	setAttr ".phl[185]" 0;
	setAttr ".phl[186]" 0;
	setAttr ".phl[187]" 0;
	setAttr ".phl[188]" 0;
	setAttr ".phl[189]" 0;
	setAttr ".phl[190]" 0;
	setAttr ".phl[191]" 0;
	setAttr ".phl[192]" 0;
	setAttr ".phl[193]" 0;
	setAttr ".phl[194]" 0;
	setAttr ".phl[195]" 0;
	setAttr ".phl[196]" 0;
	setAttr ".phl[197]" 0;
	setAttr ".phl[198]" 0;
	setAttr ".phl[199]" 0;
	setAttr ".phl[200]" 0;
	setAttr ".phl[201]" 0;
	setAttr ".phl[202]" 0;
	setAttr ".phl[203]" 0;
	setAttr ".phl[204]" 0;
	setAttr ".phl[205]" 0;
	setAttr ".phl[206]" 0;
	setAttr ".phl[207]" 0;
	setAttr ".phl[208]" 0;
	setAttr ".phl[209]" 0;
	setAttr ".phl[210]" 0;
	setAttr ".phl[211]" 0;
	setAttr ".phl[212]" 0;
	setAttr ".phl[213]" 0;
	setAttr ".phl[214]" 0;
	setAttr ".phl[215]" 0;
	setAttr ".phl[216]" 0;
	setAttr ".phl[217]" 0;
	setAttr ".phl[218]" 0;
	setAttr ".phl[219]" 0;
	setAttr ".phl[220]" 0;
	setAttr ".phl[221]" 0;
	setAttr ".phl[222]" 0;
	setAttr ".phl[223]" 0;
	setAttr ".phl[224]" 0;
	setAttr ".phl[225]" 0;
	setAttr ".phl[226]" 0;
	setAttr ".phl[227]" 0;
	setAttr ".phl[228]" 0;
	setAttr ".phl[229]" 0;
	setAttr ".phl[230]" 0;
	setAttr ".phl[231]" 0;
	setAttr ".phl[232]" 0;
	setAttr ".phl[233]" 0;
	setAttr ".phl[234]" 0;
	setAttr ".phl[235]" 0;
	setAttr ".phl[236]" 0;
	setAttr ".phl[237]" 0;
	setAttr ".phl[238]" 0;
	setAttr ".phl[239]" 0;
	setAttr ".phl[240]" 0;
	setAttr ".phl[241]" 0;
	setAttr ".phl[242]" 0;
	setAttr ".phl[243]" 0;
	setAttr ".phl[244]" 0;
	setAttr ".phl[245]" 0;
	setAttr ".phl[246]" 0;
	setAttr ".phl[247]" 0;
	setAttr ".phl[248]" 0;
	setAttr ".phl[249]" 0;
	setAttr ".phl[250]" 0;
	setAttr ".phl[251]" 0;
	setAttr ".phl[252]" 0;
	setAttr ".phl[253]" 0;
	setAttr ".phl[254]" 0;
	setAttr ".phl[255]" 0;
	setAttr ".phl[256]" 0;
	setAttr ".phl[257]" 0;
	setAttr ".phl[258]" 0;
	setAttr ".phl[259]" 0;
	setAttr ".phl[260]" 0;
	setAttr ".phl[261]" 0;
	setAttr ".phl[262]" 0;
	setAttr ".phl[263]" 0;
	setAttr ".phl[264]" 0;
	setAttr ".phl[265]" 0;
	setAttr ".phl[266]" 0;
	setAttr ".phl[267]" 0;
	setAttr ".phl[268]" 0;
	setAttr ".phl[269]" 0;
	setAttr ".phl[270]" 0;
	setAttr ".phl[271]" 0;
	setAttr ".phl[272]" 0;
	setAttr ".phl[273]" 0;
	setAttr ".phl[274]" 0;
	setAttr ".phl[275]" 0;
	setAttr ".phl[276]" 0;
	setAttr ".phl[277]" 0;
	setAttr ".phl[278]" 0;
	setAttr ".phl[279]" 0;
	setAttr ".phl[280]" 0;
	setAttr ".phl[281]" 0;
	setAttr ".phl[282]" 0;
	setAttr ".phl[283]" 0;
	setAttr ".phl[284]" 0;
	setAttr ".phl[285]" 0;
	setAttr ".phl[286]" 0;
	setAttr ".phl[287]" 0;
	setAttr ".phl[288]" 0;
	setAttr ".phl[289]" 0;
	setAttr ".phl[290]" 0;
	setAttr ".phl[291]" 0;
	setAttr ".phl[292]" 0;
	setAttr ".phl[293]" 0;
	setAttr ".phl[294]" 0;
	setAttr ".phl[295]" 0;
	setAttr ".phl[296]" 0;
	setAttr ".phl[297]" 0;
	setAttr ".phl[298]" 0;
	setAttr ".phl[299]" 0;
	setAttr ".phl[300]" 0;
	setAttr ".phl[301]" 0;
	setAttr ".phl[302]" 0;
	setAttr ".phl[303]" 0;
	setAttr ".phl[304]" 0;
	setAttr ".phl[305]" 0;
	setAttr ".phl[306]" 0;
	setAttr ".phl[307]" 0;
	setAttr ".phl[308]" 0;
	setAttr ".phl[309]" 0;
	setAttr ".phl[310]" 0;
	setAttr ".phl[311]" 0;
	setAttr ".phl[312]" 0;
	setAttr ".phl[313]" 0;
	setAttr ".phl[314]" 0;
	setAttr ".phl[315]" 0;
	setAttr ".phl[316]" 0;
	setAttr ".phl[317]" 0;
	setAttr ".phl[318]" 0;
	setAttr ".phl[319]" 0;
	setAttr ".phl[320]" 0;
	setAttr ".phl[321]" 0;
	setAttr ".phl[322]" 0;
	setAttr ".phl[323]" 0;
	setAttr ".phl[324]" 0;
	setAttr ".phl[325]" 0;
	setAttr ".phl[326]" 0;
	setAttr ".phl[327]" 0;
	setAttr ".phl[328]" 0;
	setAttr ".phl[329]" 0;
	setAttr ".phl[330]" 0;
	setAttr ".phl[331]" 0;
	setAttr ".phl[332]" 0;
	setAttr ".phl[333]" 0;
	setAttr ".phl[334]" 0;
	setAttr ".phl[335]" 0;
	setAttr ".phl[336]" 0;
	setAttr ".phl[337]" 0;
	setAttr ".phl[338]" 0;
	setAttr ".phl[339]" 0;
	setAttr ".phl[340]" 0;
	setAttr ".phl[341]" 0;
	setAttr ".phl[342]" 0;
	setAttr ".phl[343]" 0;
	setAttr ".phl[344]" 0;
	setAttr ".phl[345]" 0;
	setAttr ".phl[346]" 0;
	setAttr ".phl[347]" 0;
	setAttr ".phl[348]" 0;
	setAttr ".phl[349]" 0;
	setAttr ".phl[350]" 0;
	setAttr ".phl[351]" 0;
	setAttr ".phl[352]" 0;
	setAttr ".phl[353]" 0;
	setAttr ".phl[354]" 0;
	setAttr ".phl[355]" 0;
	setAttr ".phl[356]" 0;
	setAttr ".phl[357]" 0;
	setAttr ".phl[358]" 0;
	setAttr ".phl[359]" 0;
	setAttr ".phl[360]" 0;
	setAttr ".phl[361]" 0;
	setAttr ".phl[362]" 0;
	setAttr ".phl[363]" 0;
	setAttr ".phl[364]" 0;
	setAttr ".phl[365]" 0;
	setAttr ".phl[366]" 0;
	setAttr ".phl[367]" 0;
	setAttr ".phl[368]" 0;
	setAttr ".phl[369]" 0;
	setAttr ".phl[370]" 0;
	setAttr ".phl[371]" 0;
	setAttr ".phl[372]" 0;
	setAttr ".phl[373]" 0;
	setAttr ".phl[374]" 0;
	setAttr ".phl[375]" 0;
	setAttr ".phl[376]" 0;
	setAttr ".phl[377]" 0;
	setAttr ".phl[378]" 0;
	setAttr ".phl[379]" 0;
	setAttr ".phl[380]" 0;
	setAttr ".phl[381]" 0;
	setAttr ".phl[382]" 0;
	setAttr ".phl[383]" 0;
	setAttr ".phl[384]" 0;
	setAttr ".phl[385]" 0;
	setAttr ".phl[386]" 0;
	setAttr ".phl[387]" 0;
	setAttr ".phl[388]" 0;
	setAttr ".phl[389]" 0;
	setAttr ".phl[390]" 0;
	setAttr ".phl[391]" 0;
	setAttr ".phl[392]" 0;
	setAttr ".phl[393]" 0;
	setAttr ".phl[394]" 0;
	setAttr ".phl[395]" 0;
	setAttr ".phl[396]" 0;
	setAttr ".phl[397]" 0;
	setAttr ".phl[398]" 0;
	setAttr ".phl[399]" 0;
	setAttr ".phl[400]" 0;
	setAttr ".phl[401]" 0;
	setAttr ".phl[402]" 0;
	setAttr ".phl[403]" 0;
	setAttr ".phl[404]" 0;
	setAttr ".phl[405]" 0;
	setAttr ".phl[406]" 0;
	setAttr ".phl[407]" 0;
	setAttr ".phl[408]" 0;
	setAttr ".phl[409]" 0;
	setAttr ".phl[410]" 0;
	setAttr ".phl[411]" 0;
	setAttr ".phl[412]" 0;
	setAttr ".phl[413]" 0;
	setAttr ".phl[414]" 0;
	setAttr ".phl[415]" 0;
	setAttr ".phl[416]" 0;
	setAttr ".phl[417]" 0;
	setAttr ".phl[418]" 0;
	setAttr ".phl[419]" 0;
	setAttr ".phl[420]" 0;
	setAttr ".phl[421]" 0;
	setAttr ".phl[422]" 0;
	setAttr ".phl[423]" 0;
	setAttr ".ed" -type "dataReferenceEdits" 
		"Sid_RigRN"
		"Sid_RigRN" 0
		"Sid_RigRN" 504
		1 |Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master "blendParent1" "blendParent1" 
		" -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		2 "|Sid_Rig:Body|Sid_Rig:BodyShape" "visibility" " -k 0 1"
		2 "|Sid_Rig:Camiseta|Sid_Rig:CamisetaShape" "visibility" " -k 0 1"
		2 "|Sid_Rig:Collar_Grp" "visibility" " 0"
		2 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master" "blendParent1" " -k 1"
		
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M" 
		"uiTreatment" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M" 
		"stabilize" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"toe" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"roll" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"rollAngle" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"stretchy" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"antiPop" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"Lenght1" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"Lenght2" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R" 
		"volume" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"toe" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"roll" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"rollAngle" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"stretchy" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"antiPop" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"Lenght1" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"Lenght2" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L" 
		"volume" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R" 
		"FKIKBlend" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R" 
		"FKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R" 
		"IKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R" 
		"FKIKBlend" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R" 
		"FKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R" 
		"IKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M" 
		"FKIKBlend" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M" 
		"FKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M" 
		"IKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L" 
		"FKIKBlend" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L" 
		"FKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L" 
		"IKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L" 
		"FKIKBlend" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L" 
		"FKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L" 
		"IKVis" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M" 
		"legLock" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M" 
		"CenterBtwFeet" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"indexCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"middleCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"pinkyCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"thumbCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"spread" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L" 
		"indexCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L" 
		"middleCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L" 
		"pinkyCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L" 
		"thumbCurl" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L" 
		"spread" " -k 1"
		2 "Sid_Rig:Mesh" "displayType" " 0"
		2 "Sid_Rig:Mesh" "hideOnPlayback" " 0"
		2 "Sid_Rig:Ctrls" "hideOnPlayback" " 0"
		2 "Sid_Rig:layer1" "visibility" " 1"
		2 "Sid_Rig:layer1" "hideOnPlayback" " 0"
		3 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintTranslateX" 
		"|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.translateX" ""
		3 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintTranslateY" 
		"|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.translateY" ""
		3 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintTranslateZ" 
		"|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.translateZ" ""
		3 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintRotateX" 
		"|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.rotateX" ""
		3 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintRotateY" 
		"|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.rotateY" ""
		3 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintRotateZ" 
		"|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.rotateZ" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.translateX" 
		"Sid_RigRN.placeHolderList[1]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.translateY" 
		"Sid_RigRN.placeHolderList[2]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.translateZ" 
		"Sid_RigRN.placeHolderList[3]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.rotateX" 
		"Sid_RigRN.placeHolderList[4]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.rotateY" 
		"Sid_RigRN.placeHolderList[5]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.rotateZ" 
		"Sid_RigRN.placeHolderList[6]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.blendParent1" 
		"Sid_RigRN.placeHolderList[7]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master.blendParent1" 
		"Sid_RigRN.placeHolderList[8]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintTranslateX" 
		"Sid_RigRN.placeHolderList[9]" "Sid_Rig:Collar_Ctrl_Master.tx"
		5 3 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintTranslateY" 
		"Sid_RigRN.placeHolderList[10]" "Sid_Rig:Collar_Ctrl_Master.ty"
		5 3 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintTranslateZ" 
		"Sid_RigRN.placeHolderList[11]" "Sid_Rig:Collar_Ctrl_Master.tz"
		5 3 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintRotateX" 
		"Sid_RigRN.placeHolderList[12]" "Sid_Rig:Collar_Ctrl_Master.rx"
		5 3 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintRotateY" 
		"Sid_RigRN.placeHolderList[13]" "Sid_Rig:Collar_Ctrl_Master.ry"
		5 3 "Sid_RigRN" "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master|Sid_Rig:Collar_Ctrl_Master_parentConstraint1.constraintRotateZ" 
		"Sid_RigRN.placeHolderList[14]" "Sid_Rig:Collar_Ctrl_Master.rz"
		5 4 "Sid_RigRN" "|Sid_Rig:Main.visibility" "Sid_RigRN.placeHolderList[15]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.scaleX" "Sid_RigRN.placeHolderList[16]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.scaleY" "Sid_RigRN.placeHolderList[17]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.scaleZ" "Sid_RigRN.placeHolderList[18]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.rotateY" "Sid_RigRN.placeHolderList[19]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.rotateX" "Sid_RigRN.placeHolderList[20]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.rotateZ" "Sid_RigRN.placeHolderList[21]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.translateX" "Sid_RigRN.placeHolderList[22]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.translateY" "Sid_RigRN.placeHolderList[23]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.translateZ" "Sid_RigRN.placeHolderList[24]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_R|Sid_Rig:FKOffsetToes_R|Sid_Rig:FKFootRollIKToes_R|Sid_Rig:FKExtraToes_R|Sid_Rig:FKToes_R.rotateX" 
		"Sid_RigRN.placeHolderList[25]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_R|Sid_Rig:FKOffsetToes_R|Sid_Rig:FKFootRollIKToes_R|Sid_Rig:FKExtraToes_R|Sid_Rig:FKToes_R.rotateY" 
		"Sid_RigRN.placeHolderList[26]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_R|Sid_Rig:FKOffsetToes_R|Sid_Rig:FKFootRollIKToes_R|Sid_Rig:FKExtraToes_R|Sid_Rig:FKToes_R.rotateZ" 
		"Sid_RigRN.placeHolderList[27]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.scaleX" 
		"Sid_RigRN.placeHolderList[28]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.scaleY" 
		"Sid_RigRN.placeHolderList[29]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.scaleZ" 
		"Sid_RigRN.placeHolderList[30]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.rotateY" 
		"Sid_RigRN.placeHolderList[31]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.rotateX" 
		"Sid_RigRN.placeHolderList[32]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.rotateZ" 
		"Sid_RigRN.placeHolderList[33]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.visibility" 
		"Sid_RigRN.placeHolderList[34]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.translateX" 
		"Sid_RigRN.placeHolderList[35]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.translateY" 
		"Sid_RigRN.placeHolderList[36]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R.translateZ" 
		"Sid_RigRN.placeHolderList[37]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.scaleX" 
		"Sid_RigRN.placeHolderList[38]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.scaleY" 
		"Sid_RigRN.placeHolderList[39]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.scaleZ" 
		"Sid_RigRN.placeHolderList[40]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.rotateX" 
		"Sid_RigRN.placeHolderList[41]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.rotateY" 
		"Sid_RigRN.placeHolderList[42]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.rotateZ" 
		"Sid_RigRN.placeHolderList[43]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.visibility" 
		"Sid_RigRN.placeHolderList[44]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.translateX" 
		"Sid_RigRN.placeHolderList[45]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.translateY" 
		"Sid_RigRN.placeHolderList[46]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R.translateZ" 
		"Sid_RigRN.placeHolderList[47]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.scaleX" 
		"Sid_RigRN.placeHolderList[48]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.scaleY" 
		"Sid_RigRN.placeHolderList[49]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.scaleZ" 
		"Sid_RigRN.placeHolderList[50]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.rotateX" 
		"Sid_RigRN.placeHolderList[51]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.rotateY" 
		"Sid_RigRN.placeHolderList[52]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.rotateZ" 
		"Sid_RigRN.placeHolderList[53]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.visibility" 
		"Sid_RigRN.placeHolderList[54]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.translateX" 
		"Sid_RigRN.placeHolderList[55]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.translateY" 
		"Sid_RigRN.placeHolderList[56]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_R|Sid_Rig:FKExtraHip_R|Sid_Rig:FKHip_R|Sid_Rig:FKXHip_R|Sid_Rig:FKOffsetKnee_R|Sid_Rig:FKExtraKnee_R|Sid_Rig:FKKnee_R|Sid_Rig:FKXKnee_R|Sid_Rig:FKOffsetAnkle_R|Sid_Rig:FKExtraAnkle_R|Sid_Rig:FKAnkle_R.translateZ" 
		"Sid_RigRN.placeHolderList[57]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.scaleX" 
		"Sid_RigRN.placeHolderList[58]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.scaleY" 
		"Sid_RigRN.placeHolderList[59]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.scaleZ" 
		"Sid_RigRN.placeHolderList[60]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.rotateX" 
		"Sid_RigRN.placeHolderList[61]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.rotateY" 
		"Sid_RigRN.placeHolderList[62]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.rotateZ" 
		"Sid_RigRN.placeHolderList[63]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.visibility" 
		"Sid_RigRN.placeHolderList[64]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.translateX" 
		"Sid_RigRN.placeHolderList[65]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.translateY" 
		"Sid_RigRN.placeHolderList[66]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L.translateZ" 
		"Sid_RigRN.placeHolderList[67]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.scaleX" 
		"Sid_RigRN.placeHolderList[68]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.scaleY" 
		"Sid_RigRN.placeHolderList[69]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.scaleZ" 
		"Sid_RigRN.placeHolderList[70]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.rotateX" 
		"Sid_RigRN.placeHolderList[71]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.rotateY" 
		"Sid_RigRN.placeHolderList[72]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.rotateZ" 
		"Sid_RigRN.placeHolderList[73]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.translateX" 
		"Sid_RigRN.placeHolderList[74]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.translateY" 
		"Sid_RigRN.placeHolderList[75]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.translateZ" 
		"Sid_RigRN.placeHolderList[76]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L.visibility" 
		"Sid_RigRN.placeHolderList[77]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.scaleX" 
		"Sid_RigRN.placeHolderList[78]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.scaleY" 
		"Sid_RigRN.placeHolderList[79]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.scaleZ" 
		"Sid_RigRN.placeHolderList[80]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.rotateX" 
		"Sid_RigRN.placeHolderList[81]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.rotateY" 
		"Sid_RigRN.placeHolderList[82]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.rotateZ" 
		"Sid_RigRN.placeHolderList[83]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.translateX" 
		"Sid_RigRN.placeHolderList[84]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.translateY" 
		"Sid_RigRN.placeHolderList[85]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.translateZ" 
		"Sid_RigRN.placeHolderList[86]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToRoot_M|Sid_Rig:FKOffsetHip_L|Sid_Rig:FKExtraHip_L|Sid_Rig:FKHip_L|Sid_Rig:FKXHip_L|Sid_Rig:FKOffsetKnee_L|Sid_Rig:FKExtraKnee_L|Sid_Rig:FKKnee_L|Sid_Rig:FKXKnee_L|Sid_Rig:FKOffsetAnkle_L|Sid_Rig:FKExtraAnkle_L|Sid_Rig:FKAnkle_L.visibility" 
		"Sid_RigRN.placeHolderList[87]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.translateX" 
		"Sid_RigRN.placeHolderList[88]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.translateY" 
		"Sid_RigRN.placeHolderList[89]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.translateZ" 
		"Sid_RigRN.placeHolderList[90]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateX" 
		"Sid_RigRN.placeHolderList[91]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateY" 
		"Sid_RigRN.placeHolderList[92]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateZ" 
		"Sid_RigRN.placeHolderList[93]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.translateX" 
		"Sid_RigRN.placeHolderList[94]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.translateY" 
		"Sid_RigRN.placeHolderList[95]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.translateZ" 
		"Sid_RigRN.placeHolderList[96]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.rotateX" 
		"Sid_RigRN.placeHolderList[97]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.rotateY" 
		"Sid_RigRN.placeHolderList[98]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.rotateZ" 
		"Sid_RigRN.placeHolderList[99]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.scaleX" 
		"Sid_RigRN.placeHolderList[100]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.scaleY" 
		"Sid_RigRN.placeHolderList[101]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.scaleZ" 
		"Sid_RigRN.placeHolderList[102]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.visibility" 
		"Sid_RigRN.placeHolderList[103]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.translateX" 
		"Sid_RigRN.placeHolderList[104]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.translateY" 
		"Sid_RigRN.placeHolderList[105]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.translateZ" 
		"Sid_RigRN.placeHolderList[106]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.rotateX" 
		"Sid_RigRN.placeHolderList[107]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.rotateY" 
		"Sid_RigRN.placeHolderList[108]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.rotateZ" 
		"Sid_RigRN.placeHolderList[109]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.scaleX" 
		"Sid_RigRN.placeHolderList[110]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.scaleY" 
		"Sid_RigRN.placeHolderList[111]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.scaleZ" 
		"Sid_RigRN.placeHolderList[112]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.visibility" 
		"Sid_RigRN.placeHolderList[113]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.translateX" 
		"Sid_RigRN.placeHolderList[114]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.translateY" 
		"Sid_RigRN.placeHolderList[115]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.translateZ" 
		"Sid_RigRN.placeHolderList[116]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateX" 
		"Sid_RigRN.placeHolderList[117]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateY" 
		"Sid_RigRN.placeHolderList[118]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateZ" 
		"Sid_RigRN.placeHolderList[119]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateX" 
		"Sid_RigRN.placeHolderList[120]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateX" 
		"Sid_RigRN.placeHolderList[121]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateY" 
		"Sid_RigRN.placeHolderList[122]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateY" 
		"Sid_RigRN.placeHolderList[123]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateZ" 
		"Sid_RigRN.placeHolderList[124]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateZ" 
		"Sid_RigRN.placeHolderList[125]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[126]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[127]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateX" 
		"Sid_RigRN.placeHolderList[128]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateX" 
		"Sid_RigRN.placeHolderList[129]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateY" 
		"Sid_RigRN.placeHolderList[130]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateY" 
		"Sid_RigRN.placeHolderList[131]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[132]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[133]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[134]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[135]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateX" 
		"Sid_RigRN.placeHolderList[136]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateX" 
		"Sid_RigRN.placeHolderList[137]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateY" 
		"Sid_RigRN.placeHolderList[138]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateY" 
		"Sid_RigRN.placeHolderList[139]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateZ" 
		"Sid_RigRN.placeHolderList[140]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateZ" 
		"Sid_RigRN.placeHolderList[141]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[142]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[143]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateX" 
		"Sid_RigRN.placeHolderList[144]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateX" 
		"Sid_RigRN.placeHolderList[145]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateY" 
		"Sid_RigRN.placeHolderList[146]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateY" 
		"Sid_RigRN.placeHolderList[147]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[148]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[149]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[150]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[151]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateX" 
		"Sid_RigRN.placeHolderList[152]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateX" 
		"Sid_RigRN.placeHolderList[153]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateY" 
		"Sid_RigRN.placeHolderList[154]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateY" 
		"Sid_RigRN.placeHolderList[155]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateZ" 
		"Sid_RigRN.placeHolderList[156]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateZ" 
		"Sid_RigRN.placeHolderList[157]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[158]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[159]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateX" 
		"Sid_RigRN.placeHolderList[160]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateX" 
		"Sid_RigRN.placeHolderList[161]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateY" 
		"Sid_RigRN.placeHolderList[162]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateY" 
		"Sid_RigRN.placeHolderList[163]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateZ" 
		"Sid_RigRN.placeHolderList[164]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateZ" 
		"Sid_RigRN.placeHolderList[165]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[166]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[167]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[168]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateY" 
		"Sid_RigRN.placeHolderList[169]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateY" 
		"Sid_RigRN.placeHolderList[170]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateX" 
		"Sid_RigRN.placeHolderList[171]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateX" 
		"Sid_RigRN.placeHolderList[172]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[173]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateX" 
		"Sid_RigRN.placeHolderList[174]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateX" 
		"Sid_RigRN.placeHolderList[175]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateY" 
		"Sid_RigRN.placeHolderList[176]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateY" 
		"Sid_RigRN.placeHolderList[177]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateZ" 
		"Sid_RigRN.placeHolderList[178]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateZ" 
		"Sid_RigRN.placeHolderList[179]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[180]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateX" 
		"Sid_RigRN.placeHolderList[181]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateX" 
		"Sid_RigRN.placeHolderList[182]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateY" 
		"Sid_RigRN.placeHolderList[183]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateY" 
		"Sid_RigRN.placeHolderList[184]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[185]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[186]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[187]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateX" 
		"Sid_RigRN.placeHolderList[188]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateX" 
		"Sid_RigRN.placeHolderList[189]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateY" 
		"Sid_RigRN.placeHolderList[190]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateY" 
		"Sid_RigRN.placeHolderList[191]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateZ" 
		"Sid_RigRN.placeHolderList[192]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateZ" 
		"Sid_RigRN.placeHolderList[193]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[194]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[195]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[196]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[197]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[198]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[199]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[200]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[201]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[202]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[203]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[204]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[205]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[206]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[207]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[208]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[209]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[210]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[211]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[212]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[213]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[214]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[215]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[216]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[217]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[218]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[219]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[220]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[221]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[222]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[223]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[224]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[225]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[226]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[227]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[228]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[229]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[230]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.uiTreatment" 
		"Sid_RigRN.placeHolderList[231]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateX" 
		"Sid_RigRN.placeHolderList[232]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateY" 
		"Sid_RigRN.placeHolderList[233]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateZ" 
		"Sid_RigRN.placeHolderList[234]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateX" 
		"Sid_RigRN.placeHolderList[235]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateY" 
		"Sid_RigRN.placeHolderList[236]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateZ" 
		"Sid_RigRN.placeHolderList[237]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateX" 
		"Sid_RigRN.placeHolderList[238]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateY" 
		"Sid_RigRN.placeHolderList[239]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateZ" 
		"Sid_RigRN.placeHolderList[240]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateX" 
		"Sid_RigRN.placeHolderList[241]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateY" 
		"Sid_RigRN.placeHolderList[242]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateZ" 
		"Sid_RigRN.placeHolderList[243]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.translateX" 
		"Sid_RigRN.placeHolderList[244]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.translateY" 
		"Sid_RigRN.placeHolderList[245]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.translateZ" 
		"Sid_RigRN.placeHolderList[246]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateX" 
		"Sid_RigRN.placeHolderList[247]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateY" 
		"Sid_RigRN.placeHolderList[248]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateZ" 
		"Sid_RigRN.placeHolderList[249]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateX" 
		"Sid_RigRN.placeHolderList[250]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateY" 
		"Sid_RigRN.placeHolderList[251]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateZ" 
		"Sid_RigRN.placeHolderList[252]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[253]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[254]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[255]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[256]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[257]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[258]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[259]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[260]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[261]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[262]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[263]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[264]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[265]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[266]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[267]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[268]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[269]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[270]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[271]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[272]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[273]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[274]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[275]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[276]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[277]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[278]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[279]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[280]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[281]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[282]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[283]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[284]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[285]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[286]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[287]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[288]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateX" 
		"Sid_RigRN.placeHolderList[289]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateY" 
		"Sid_RigRN.placeHolderList[290]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateZ" 
		"Sid_RigRN.placeHolderList[291]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.stabilize" 
		"Sid_RigRN.placeHolderList[292]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateY" 
		"Sid_RigRN.placeHolderList[293]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateZ" 
		"Sid_RigRN.placeHolderList[294]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateX" 
		"Sid_RigRN.placeHolderList[295]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateX" 
		"Sid_RigRN.placeHolderList[296]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateY" 
		"Sid_RigRN.placeHolderList[297]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateZ" 
		"Sid_RigRN.placeHolderList[298]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.toe" 
		"Sid_RigRN.placeHolderList[299]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rollAngle" 
		"Sid_RigRN.placeHolderList[300]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.roll" 
		"Sid_RigRN.placeHolderList[301]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.stretchy" 
		"Sid_RigRN.placeHolderList[302]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.antiPop" 
		"Sid_RigRN.placeHolderList[303]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght1" 
		"Sid_RigRN.placeHolderList[304]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght2" 
		"Sid_RigRN.placeHolderList[305]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.volume" 
		"Sid_RigRN.placeHolderList[306]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateX" 
		"Sid_RigRN.placeHolderList[307]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateY" 
		"Sid_RigRN.placeHolderList[308]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateZ" 
		"Sid_RigRN.placeHolderList[309]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.visibility" 
		"Sid_RigRN.placeHolderList[310]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateX" 
		"Sid_RigRN.placeHolderList[311]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateY" 
		"Sid_RigRN.placeHolderList[312]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateZ" 
		"Sid_RigRN.placeHolderList[313]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleX" 
		"Sid_RigRN.placeHolderList[314]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleY" 
		"Sid_RigRN.placeHolderList[315]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleZ" 
		"Sid_RigRN.placeHolderList[316]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateX" 
		"Sid_RigRN.placeHolderList[317]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateY" 
		"Sid_RigRN.placeHolderList[318]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateZ" 
		"Sid_RigRN.placeHolderList[319]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.visibility" 
		"Sid_RigRN.placeHolderList[320]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateX" 
		"Sid_RigRN.placeHolderList[321]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateY" 
		"Sid_RigRN.placeHolderList[322]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateZ" 
		"Sid_RigRN.placeHolderList[323]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleX" 
		"Sid_RigRN.placeHolderList[324]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleY" 
		"Sid_RigRN.placeHolderList[325]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleZ" 
		"Sid_RigRN.placeHolderList[326]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateZ" 
		"Sid_RigRN.placeHolderList[327]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateX" 
		"Sid_RigRN.placeHolderList[328]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateY" 
		"Sid_RigRN.placeHolderList[329]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateX" 
		"Sid_RigRN.placeHolderList[330]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateY" 
		"Sid_RigRN.placeHolderList[331]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateZ" 
		"Sid_RigRN.placeHolderList[332]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.visibility" 
		"Sid_RigRN.placeHolderList[333]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleX" 
		"Sid_RigRN.placeHolderList[334]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleY" 
		"Sid_RigRN.placeHolderList[335]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleZ" 
		"Sid_RigRN.placeHolderList[336]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateX" 
		"Sid_RigRN.placeHolderList[337]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateY" 
		"Sid_RigRN.placeHolderList[338]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateZ" 
		"Sid_RigRN.placeHolderList[339]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.follow" 
		"Sid_RigRN.placeHolderList[340]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.lock" 
		"Sid_RigRN.placeHolderList[341]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateY" 
		"Sid_RigRN.placeHolderList[342]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateZ" 
		"Sid_RigRN.placeHolderList[343]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateX" 
		"Sid_RigRN.placeHolderList[344]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateX" 
		"Sid_RigRN.placeHolderList[345]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateY" 
		"Sid_RigRN.placeHolderList[346]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateZ" 
		"Sid_RigRN.placeHolderList[347]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.toe" 
		"Sid_RigRN.placeHolderList[348]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rollAngle" 
		"Sid_RigRN.placeHolderList[349]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.roll" 
		"Sid_RigRN.placeHolderList[350]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.stretchy" 
		"Sid_RigRN.placeHolderList[351]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.antiPop" 
		"Sid_RigRN.placeHolderList[352]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght1" 
		"Sid_RigRN.placeHolderList[353]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght2" 
		"Sid_RigRN.placeHolderList[354]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.volume" 
		"Sid_RigRN.placeHolderList[355]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateX" 
		"Sid_RigRN.placeHolderList[356]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateY" 
		"Sid_RigRN.placeHolderList[357]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateZ" 
		"Sid_RigRN.placeHolderList[358]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.visibility" 
		"Sid_RigRN.placeHolderList[359]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateX" 
		"Sid_RigRN.placeHolderList[360]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateY" 
		"Sid_RigRN.placeHolderList[361]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateZ" 
		"Sid_RigRN.placeHolderList[362]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleX" 
		"Sid_RigRN.placeHolderList[363]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleY" 
		"Sid_RigRN.placeHolderList[364]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleZ" 
		"Sid_RigRN.placeHolderList[365]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateX" 
		"Sid_RigRN.placeHolderList[366]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateY" 
		"Sid_RigRN.placeHolderList[367]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateZ" 
		"Sid_RigRN.placeHolderList[368]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.visibility" 
		"Sid_RigRN.placeHolderList[369]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateX" 
		"Sid_RigRN.placeHolderList[370]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateY" 
		"Sid_RigRN.placeHolderList[371]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateZ" 
		"Sid_RigRN.placeHolderList[372]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleX" 
		"Sid_RigRN.placeHolderList[373]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleY" 
		"Sid_RigRN.placeHolderList[374]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleZ" 
		"Sid_RigRN.placeHolderList[375]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateZ" 
		"Sid_RigRN.placeHolderList[376]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateX" 
		"Sid_RigRN.placeHolderList[377]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateY" 
		"Sid_RigRN.placeHolderList[378]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateX" 
		"Sid_RigRN.placeHolderList[379]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateY" 
		"Sid_RigRN.placeHolderList[380]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateZ" 
		"Sid_RigRN.placeHolderList[381]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.visibility" 
		"Sid_RigRN.placeHolderList[382]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleX" 
		"Sid_RigRN.placeHolderList[383]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleY" 
		"Sid_RigRN.placeHolderList[384]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleZ" 
		"Sid_RigRN.placeHolderList[385]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateX" 
		"Sid_RigRN.placeHolderList[386]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateY" 
		"Sid_RigRN.placeHolderList[387]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateZ" 
		"Sid_RigRN.placeHolderList[388]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.follow" 
		"Sid_RigRN.placeHolderList[389]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.lock" 
		"Sid_RigRN.placeHolderList[390]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.FKIKBlend" 
		"Sid_RigRN.placeHolderList[391]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.IKVis" 
		"Sid_RigRN.placeHolderList[392]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.FKVis" 
		"Sid_RigRN.placeHolderList[393]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.FKIKBlend" 
		"Sid_RigRN.placeHolderList[394]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.IKVis" 
		"Sid_RigRN.placeHolderList[395]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.FKVis" 
		"Sid_RigRN.placeHolderList[396]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.FKIKBlend" 
		"Sid_RigRN.placeHolderList[397]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.IKVis" 
		"Sid_RigRN.placeHolderList[398]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.FKVis" 
		"Sid_RigRN.placeHolderList[399]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.FKIKBlend" 
		"Sid_RigRN.placeHolderList[400]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.IKVis" 
		"Sid_RigRN.placeHolderList[401]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.FKVis" 
		"Sid_RigRN.placeHolderList[402]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.FKIKBlend" 
		"Sid_RigRN.placeHolderList[403]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.IKVis" 
		"Sid_RigRN.placeHolderList[404]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.FKVis" 
		"Sid_RigRN.placeHolderList[405]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateZ" 
		"Sid_RigRN.placeHolderList[406]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateX" 
		"Sid_RigRN.placeHolderList[407]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateY" 
		"Sid_RigRN.placeHolderList[408]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.legLock" 
		"Sid_RigRN.placeHolderList[409]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.CenterBtwFeet" 
		"Sid_RigRN.placeHolderList[410]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateX" 
		"Sid_RigRN.placeHolderList[411]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateY" 
		"Sid_RigRN.placeHolderList[412]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateZ" 
		"Sid_RigRN.placeHolderList[413]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.indexCurl" 
		"Sid_RigRN.placeHolderList[414]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.middleCurl" 
		"Sid_RigRN.placeHolderList[415]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.pinkyCurl" 
		"Sid_RigRN.placeHolderList[416]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.thumbCurl" 
		"Sid_RigRN.placeHolderList[417]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.spread" 
		"Sid_RigRN.placeHolderList[418]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.indexCurl" 
		"Sid_RigRN.placeHolderList[419]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.middleCurl" 
		"Sid_RigRN.placeHolderList[420]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.pinkyCurl" 
		"Sid_RigRN.placeHolderList[421]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.thumbCurl" 
		"Sid_RigRN.placeHolderList[422]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.spread" 
		"Sid_RigRN.placeHolderList[423]" "";
	setAttr ".ptag" -type "string" "";
lockNode -l 1 ;
createNode ilrOptionsNode -s -n "TurtleRenderOptions";
	rename -uid "9ECAF114-40F5-8924-3AFB-F6BC3A7B3EDC";
lockNode -l 1 ;
createNode ilrUIOptionsNode -s -n "TurtleUIOptions";
	rename -uid "EEF78DB7-4996-480E-5CA7-F1AD5EBB0BD7";
lockNode -l 1 ;
createNode ilrBakeLayerManager -s -n "TurtleBakeLayerManager";
	rename -uid "6B2B26CC-4758-5258-66B1-F7A1753C32D4";
lockNode -l 1 ;
createNode ilrBakeLayer -s -n "TurtleDefaultBakeLayer";
	rename -uid "BF38C121-4517-CDF1-E7E9-D5939BA99F03";
lockNode -l 1 ;
createNode animCurveTA -n "Main_rotateX";
	rename -uid "41252D69-464A-663D-E7FA-7CB568BF7023";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Main_rotateY";
	rename -uid "AF756D73-40CB-509E-11C9-F7B4B2F4908B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Main_rotateZ";
	rename -uid "5E42B875-4801-E075-DC1C-069510626B1E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "Main_visibility";
	rename -uid "F4BC1DAB-400E-10C5-B0A3-F7A92B86AF35";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTL -n "Main_translateX";
	rename -uid "CDD55BA8-4C6C-8852-9C3F-B896D77A1EBB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Main_translateY";
	rename -uid "EF036398-426B-EBD0-5231-4280C78DC1B9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Main_translateZ";
	rename -uid "FF2AD829-4603-50C1-2C0E-638B97ACD99F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "Main_scaleX";
	rename -uid "32D82B6E-4B57-82DE-E56F-8CA76BF8FB25";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTU -n "Main_scaleY";
	rename -uid "5837152F-46B2-D707-1F07-DEB3D2808CDB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTU -n "Main_scaleZ";
	rename -uid "EF726E16-41A7-6C08-65E9-B0B04908E8B7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode pairBlend -n "pairBlend1";
	rename -uid "B0ACADEA-418F-032C-8F59-33BD71A82E8B";
createNode animCurveTL -n "pairBlend1_inTranslateX1";
	rename -uid "589DC36B-4647-A385-B655-36A4BF155132";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -0.36504403518907946 10 -1.1499658297678568
		 16 -1.1499658297678568 20 -1.1499658297678568 26 -1.1499658297678568 30 -0.36504403518907946;
createNode animCurveTL -n "pairBlend1_inTranslateY1";
	rename -uid "94827AA2-482C-4F7E-F73B-E9A185CE7E29";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -11.810777230760515 10 -0.36867663948750717
		 16 -0.36867663948750717 20 -0.36867663948750717 26 -0.36867663948750717 30 -11.810777230760515;
createNode animCurveTL -n "pairBlend1_inTranslateZ1";
	rename -uid "96811D88-469C-D09A-B249-0EA8F70F1CBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 7.4329404525933231 10 -0.18023933875742104
		 16 -0.18023933875742104 20 -0.18023933875742104 26 -0.18023933875742104 30 7.4329404525933231;
createNode animCurveTL -n "FKSpine1_M_translateX";
	rename -uid "1A6702F4-4741-60B0-5465-AB91511B98D3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -0.33053596001870567 3 0 9 0 14 0 16 0
		 22 0 26 -0.33053596001870567;
createNode animCurveTL -n "FKSpine1_M_translateY";
	rename -uid "85B6FEF2-4BF3-B86F-7DF8-3A88DCED1AC5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKSpine1_M_translateZ";
	rename -uid "DE80B3B1-45D0-A153-7903-EC9F33568908";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKChest_M_translateX";
	rename -uid "B02285C4-44E3-F354-88A7-2F85ADBA075E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -0.33053596001870567 3 0 9 0 14 0 16 0
		 22 0 26 -0.33053596001870567;
createNode animCurveTL -n "FKChest_M_translateY";
	rename -uid "F4E31E33-4EA0-E6C8-79AE-B1B091D7481A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKChest_M_translateZ";
	rename -uid "CA1189E0-4733-39E1-1275-48B1ADAD947C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKRoot_M_translateX";
	rename -uid "CDD26E9D-4DC8-2572-3F5C-4BA014EA9AA6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKRoot_M_translateY";
	rename -uid "E964786D-4EFB-6B96-2BD2-C4BD49B62CB7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKRoot_M_translateZ";
	rename -uid "A6C44751-4CF2-7590-6652-7BBC5C852FBE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKHead_M_translateX";
	rename -uid "B5B3ED31-4292-210B-859E-988F88E59F1A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKHead_M_translateY";
	rename -uid "62729725-4670-AB64-8CE2-018D83AAAAFD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "FKHead_M_translateZ";
	rename -uid "FB3AD24A-458C-2F42-D239-BAB521ACFFF1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Bigote01_Ctrl_translateX";
	rename -uid "80BA1140-4A92-E3CC-FF61-428F31B7C8C1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Bigote01_Ctrl_translateY";
	rename -uid "8D068527-4C18-6908-3B9C-C08635E5C9BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Bigote01_Ctrl_translateZ";
	rename -uid "7D65CE55-4D73-8112-7149-159AEE173D7C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Bigote02_Ctrl_translateX";
	rename -uid "FB10DA52-4ACE-9CB2-506D-6B8825B70FE4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Bigote02_Ctrl_translateY";
	rename -uid "E8A88F0C-4F57-E7B9-6C7C-FE8EAFD03600";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Bigote02_Ctrl_translateZ";
	rename -uid "FDE6B574-4EC8-8D39-AC6B-B5B84032A608";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Gorro_Ctrl_translateX";
	rename -uid "9AFDBCE6-4F48-4651-D38A-B98852637E89";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Gorro_Ctrl_translateY";
	rename -uid "9660A50C-45B9-17EE-B63C-69A0210DCBE2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "Gorro_Ctrl_translateZ";
	rename -uid "BEB0E493-4645-DBC6-768B-55B63E07B435";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTL -n "IKLeg_L_translateX";
	rename -uid "248C5E4C-4177-D328-6749-0AB3B001B003";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 -0.85237052038651484 3 -0.85237052038651484
		 10 8.8158256646492568 22 8.8158256646492568 26 -0.85237052038651484;
createNode animCurveTL -n "IKLeg_L_translateY";
	rename -uid "A95C7999-49AC-A5C9-D684-3E8F8F4DAFDE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 19.95542193914202 22 19.95542193914202
		 26 0;
createNode animCurveTL -n "IKLeg_L_translateZ";
	rename -uid "B6E592F5-4162-982D-8392-538F6B414341";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 20.719779013499789 22 20.719779013499789
		 26 0;
createNode animCurveTL -n "RollHeel_L_translateX";
	rename -uid "F88BFE78-45D6-D7CC-C33E-789F9D94552D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollHeel_L_translateY";
	rename -uid "EF5FF163-47AF-2DDC-C2C5-1B9EF5004834";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollHeel_L_translateZ";
	rename -uid "0E391530-4DE7-BFD6-ACFE-FB9295CCB04E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToesEnd_L_translateX";
	rename -uid "34103C85-42D5-4717-B6A9-51BF7D31A0D7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToesEnd_L_translateY";
	rename -uid "EE7DA51E-4D5A-2F49-DD8C-7D9825D130B7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToesEnd_L_translateZ";
	rename -uid "D7F6F4B7-4009-F34F-84E1-E28CE5D9ACD8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToes_L_translateX";
	rename -uid "29D67ACF-4E74-E0F7-1BAF-D4ACDD499863";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToes_L_translateY";
	rename -uid "52D8BB16-4000-EE80-E3AF-5C962652FE2A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToes_L_translateZ";
	rename -uid "0E7CA823-4474-B023-ABF8-F8A39FA4EE4D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "IKLeg_R_translateX";
	rename -uid "954EFA34-4BF0-0652-506F-D0B834739FD4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 -7.7662944682477342 22 -7.7662944682477342
		 26 0;
createNode animCurveTL -n "IKLeg_R_translateY";
	rename -uid "A91D0EF3-4E0F-5277-5A9C-DBB63A4BED9A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 17.541018983337253 22 17.541018983337253
		 26 0;
createNode animCurveTL -n "IKLeg_R_translateZ";
	rename -uid "4D757595-4191-2008-AB4F-E88867FFE63D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 -17.218911351250618 22 -17.218911351250618
		 26 0;
createNode animCurveTL -n "RollHeel_R_translateX";
	rename -uid "88860648-4F73-0BEF-0B47-598B4E7C288B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollHeel_R_translateY";
	rename -uid "120DD65D-431B-1129-F534-53894DB2D7D4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollHeel_R_translateZ";
	rename -uid "D0EBAB9A-4962-7A45-E384-0499FD2CA8DB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToesEnd_R_translateX";
	rename -uid "F91DD54E-4D15-392D-CC4B-8FB7BFB51690";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToesEnd_R_translateY";
	rename -uid "6E10B5B7-4CA6-A122-F5C2-C7A98A5BFF0D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToesEnd_R_translateZ";
	rename -uid "58DC11D7-4DE2-FEB2-B348-34BBA254330F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToes_R_translateX";
	rename -uid "FD346983-4CFE-74E5-56DA-D3B87B1F610B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToes_R_translateY";
	rename -uid "41399744-4ED4-D021-A01B-A5A99C444846";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "RollToes_R_translateZ";
	rename -uid "8ED8056E-482F-053B-D0F3-0B8D23CDD886";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "PoleLeg_L_translateX";
	rename -uid "AB8A912F-40EB-0D81-A47C-6E86D801C8E9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "PoleLeg_L_translateY";
	rename -uid "FDA3EFA0-4385-AC6D-5EAA-28BDA7FA9211";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "PoleLeg_L_translateZ";
	rename -uid "919E88B8-4962-B521-1771-4D9154CF8AC4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTL -n "PoleLeg_R_translateX";
	rename -uid "8125BA75-4E13-D496-E2EA-5480B88AF7E3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1.308705702166163 10 1.308705702166163
		 26 1.308705702166163 30 1.308705702166163;
createNode animCurveTL -n "PoleLeg_R_translateY";
	rename -uid "B7E1178F-42F0-3E74-C596-CA9F12717C46";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 -2.0677980512681131 10 -2.0677980512681131
		 26 -2.0677980512681131 30 -2.0677980512681131;
createNode animCurveTL -n "PoleLeg_R_translateZ";
	rename -uid "EA2E80E3-424F-953A-C166-E5BDBE16D937";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0.64784335859208297 10 0.64784335859208297
		 26 0.64784335859208297 30 0.64784335859208297;
createNode animCurveTL -n "RootX_M_translateX";
	rename -uid "53AF8E45-47C3-56FC-3524-5CBCC3C63AA3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -0.3061792213269392 9 -0.29968661048557621
		 14 -0.29968661048557621 16 -0.29968661048557621 22 -0.29968661048557621 26 -0.3061792213269392;
createNode animCurveTL -n "RootX_M_translateY";
	rename -uid "086E86AA-44FD-8602-6975-C1876B4A7F2D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -11.745600296183213 3 0.089567847014141222
		 9 2.8497144965415693 14 0.1516380292934123 16 0.1516380292934123 22 0.1516380292934123
		 26 -11.745600296183213;
createNode animCurveTL -n "RootX_M_translateZ";
	rename -uid "A02290EE-411E-089F-20D8-89A5F1D2426D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0.71783875753236881 3 3.2153642537764222
		 9 0 14 0 16 0 22 0 26 0.71783875753236881;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateX";
	rename -uid "480C9AB6-43F5-1F25-1A5A-88A681F8AF15";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateY";
	rename -uid "7B208966-4B39-A315-CC8B-C581E6D25D0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateZ";
	rename -uid "1BFC8444-4EB3-D6FF-3767-799FEDB61EF8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger1_L_rotateX";
	rename -uid "2BEE21DE-43BF-7283-F985-1BBAD2940B91";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger1_L_rotateY";
	rename -uid "D8211A35-4767-F144-89AF-7DB9A4E82F44";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger1_L_rotateZ";
	rename -uid "388543D5-4229-D546-C630-F2A9714BF762";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKElbow1_L_rotateX";
	rename -uid "6A77EFDB-41FE-939B-1495-E8A982431B20";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 357.23671618652924 3 0 9 -0.50830015238847071
		 14 -0.50830015238847071 16 -0.50830015238847071 22 -0.50830015238847071 26 357.23671618652924;
createNode animCurveTA -n "FKElbow1_L_rotateY";
	rename -uid "6E04EF2D-4F4D-5A0E-E3F6-999621C02CF0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -9.5024731322485891 3 16.843827808163436
		 9 12.862877478589306 14 12.862877478589306 16 12.862877478589306 22 12.862877478589306
		 26 -9.5024731322485891;
createNode animCurveTA -n "FKElbow1_L_rotateZ";
	rename -uid "1D049B97-4302-35CE-0FA3-C68230777CC5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -319.40782562620143 3 0 9 -6.8380457415192382
		 14 -6.8380457415192382 16 -6.8380457415192382 22 -6.8380457415192382 26 -319.40782562620143;
createNode animCurveTA -n "FKChest_M_rotateX";
	rename -uid "F4620EC8-4968-37DF-8865-789FE8AC0991";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 24.303859507239359 14 24.303859507239359
		 16 24.303859507239359 22 24.303859507239359 26 0;
createNode animCurveTA -n "FKChest_M_rotateY";
	rename -uid "AB02B205-4B09-7F27-1C86-0AA793D0B7F0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 -18.502495980623966 14 -18.502495980623966
		 16 -18.502495980623966 22 -18.502495980623966 26 0;
createNode animCurveTA -n "FKChest_M_rotateZ";
	rename -uid "C45DE5E6-4DC8-2035-822D-DBB77EB0E2BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 14.736202721112454 3 0 9 3.443323615921221
		 14 3.443323615921221 16 3.443323615921221 22 3.443323615921221 26 14.736202721112454;
createNode animCurveTA -n "FKShoulder_R_rotateX";
	rename -uid "ADFF6087-4559-BB87-6EA7-E5ACC9FAAF55";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 2.4502457484008833 3 0 9 0 14 0 16 0 22 0
		 26 2.4502457484008833;
createNode animCurveTA -n "FKShoulder_R_rotateY";
	rename -uid "8A02DFF2-4270-4D7A-D16F-088A5B52EED1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -4.505457416908107 3 7.8359145231588121
		 9 0 14 0 16 0 22 0 26 -4.505457416908107;
createNode animCurveTA -n "FKShoulder_R_rotateZ";
	rename -uid "61EFA11B-4569-44BF-D703-B8BF8AFE4835";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 7.1291147983233669 3 0 9 0 14 0 16 0 22 0
		 26 7.1291147983233669;
createNode animCurveTU -n "RollToes_R_visibility";
	rename -uid "C6E86FA1-4420-01AC-E774-488FD7266CD3";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTA -n "RollToes_R_rotateX";
	rename -uid "B4722EF4-496E-909D-AC67-AA925B6367EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToes_R_rotateY";
	rename -uid "8A14EDB0-4455-FF85-6C5A-67815111A480";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToes_R_rotateZ";
	rename -uid "E41FBE63-4FD3-6EAA-F572-308BBF8E0E46";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTU -n "RollToes_R_scaleX";
	rename -uid "C6FEAFB1-44C5-18C9-4DD2-79982D13F9DE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToes_R_scaleY";
	rename -uid "0DC837D3-4ED7-0424-4604-0C8DF581CCCC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToes_R_scaleZ";
	rename -uid "53B1B8A2-462E-025B-5433-D995265CFFBA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTA -n "FKShoulder1_R_rotateX";
	rename -uid "68407FB3-4D58-C6EB-C57A-CD9C9AFD956A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -55.30614043118532 3 0 9 -68.135238754044607
		 14 -68.135238754044607 16 -68.135238754044607 22 -68.135238754044607 26 -55.30614043118532;
createNode animCurveTA -n "FKShoulder1_R_rotateY";
	rename -uid "BC15AF37-489D-EF05-2049-ED877E9F1749";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -8.4086514745223635 3 66.754283990917884
		 9 24.21900918143589 14 24.21900918143589 16 24.21900918143589 22 24.21900918143589
		 26 -8.4086514745223635;
createNode animCurveTA -n "FKShoulder1_R_rotateZ";
	rename -uid "62F098A5-401B-9665-E99A-208854B0F6CA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -55.898186872522373 3 0 9 -80.651998817207442
		 14 -80.651998817207442 16 -80.651998817207442 22 -80.651998817207442 26 -55.898186872522373;
createNode animCurveTA -n "FKThumbFinger1_R_rotateX";
	rename -uid "962792AA-45F4-F00A-C66A-87836AA56D74";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger1_R_rotateY";
	rename -uid "E1173CD4-45B6-FD46-D731-F19B3D498B34";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger1_R_rotateZ";
	rename -uid "6B720B8E-4842-9003-6E65-41A4A4AB18D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "PoleLeg_L_follow";
	rename -uid "7F118BD5-406A-0F0D-23B2-F4AF5601D78E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 10 10 10 26 10 30 10;
createNode animCurveTU -n "PoleLeg_L_lock";
	rename -uid "1A34A2C5-4FFA-D321-2E8C-4983FD55DA6A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "FKThumbFinger3_R_rotateX";
	rename -uid "CC9A0F5F-40E9-733C-B350-E8AC13CE3203";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger3_R_rotateY";
	rename -uid "92C95F97-4148-D03C-7E04-EB805F716A3B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger3_R_rotateZ";
	rename -uid "196C14CA-4C84-3532-B66C-88B17615B37A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "RollToes_L_visibility";
	rename -uid "76792953-4749-C97D-C418-44920DB94698";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTA -n "RollToes_L_rotateX";
	rename -uid "A7501EB1-4D6D-BD51-3BB4-3499CDFE3312";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToes_L_rotateY";
	rename -uid "31DA3CB2-43BA-4ED7-D064-8880C20325F9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToes_L_rotateZ";
	rename -uid "AD260ECA-4A1C-7A84-0663-BAA64DF749F8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTU -n "RollToes_L_scaleX";
	rename -uid "7B6817F6-41EA-03C4-29C3-77B8A0DA4E10";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToes_L_scaleY";
	rename -uid "159EFC6E-4E3C-E262-F052-01891C07E4A2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToes_L_scaleZ";
	rename -uid "205A42A4-444D-6627-6A81-DD91AA3DBE3D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "FKIKArm_R_FKIKBlend";
	rename -uid "B8EFFB85-4D6E-B4E7-1E83-AABC819C2E8C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "FKIKArm_R_FKVis";
	rename -uid "12DC712B-4626-6F59-16A7-21858B656ACF";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTU -n "FKIKArm_R_IKVis";
	rename -uid "60BF54C9-4274-0459-BCC9-04972B926A8E";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTA -n "FKToes_L_rotateX";
	rename -uid "1C60D478-4F22-FE9E-9C39-73B874EEDF62";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKToes_L_rotateY";
	rename -uid "B3E98250-4B32-B93B-EFCC-519CDB88AE5F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKToes_L_rotateZ";
	rename -uid "659A5183-4BDD-0E99-5760-CB93B9C99E98";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "Bigote01_Ctrl_visibility";
	rename -uid "B08FB22C-43AE-16DB-13D6-B987D2CBDAF1";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTA -n "Bigote01_Ctrl_rotateX";
	rename -uid "E533C1E7-4D9D-1249-585B-28BB78D07248";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Bigote01_Ctrl_rotateY";
	rename -uid "D8DF212A-47F0-23F4-89F5-3A88C9C81627";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Bigote01_Ctrl_rotateZ";
	rename -uid "48DD50A9-4258-8FB4-EA55-F3A3A83A8467";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "Bigote01_Ctrl_scaleX";
	rename -uid "216118C8-4E9D-D86B-3B99-EA9F56DE72A3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTU -n "Bigote01_Ctrl_scaleY";
	rename -uid "1C7C094B-40BA-A791-E3DC-ADBF5932A1C4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTU -n "Bigote01_Ctrl_scaleZ";
	rename -uid "D013EF4A-4168-5097-3E0F-3F8ABAC02AEA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTA -n "IKLeg_L_rotateX";
	rename -uid "BD87732A-43F1-9924-0328-5F9CA64FDF84";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 -87.426092894884533 22 -87.426092894884533
		 26 0;
createNode animCurveTA -n "IKLeg_L_rotateY";
	rename -uid "394387C1-42C6-4A25-C38F-BBB51FA5E3C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 -3.3133110497915088 3 -3.3133110497915088
		 10 34.812569586861692 22 34.812569586861692 26 -3.3133110497915088;
createNode animCurveTA -n "IKLeg_L_rotateZ";
	rename -uid "F450865F-41FF-094C-2D12-7C8735828253";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 -16.232453022155187 22 -16.232453022155187
		 26 0;
createNode animCurveTU -n "IKLeg_L_toe";
	rename -uid "D696EA0E-482F-E1E8-D7ED-C0A1C12F81F5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_L_roll";
	rename -uid "F273E7EF-4C70-75A0-D1D6-71A83D2AD25E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_L_rollAngle";
	rename -uid "2845142C-4443-735F-3673-CE8359B69276";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 25 3 25 10 25 22 25 26 25;
createNode animCurveTU -n "IKLeg_L_stretchy";
	rename -uid "073BB2FE-4493-91C5-43FD-D2BA4B3637CF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_L_antiPop";
	rename -uid "BE7995A7-40F0-8926-2540-FA86D2C9F985";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_L_Lenght1";
	rename -uid "07BCF5C2-4C8C-F93C-B12A-AD8845F05C36";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1 3 1 10 1.25 22 1.25 26 1;
createNode animCurveTU -n "IKLeg_L_Lenght2";
	rename -uid "6EB89614-4A2A-0950-746F-6EAA75ED9968";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1 3 1 10 1.25 22 1.25 26 1;
createNode animCurveTU -n "IKLeg_L_volume";
	rename -uid "A1F33051-4D63-FEB1-2909-2BB55A98D593";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 10 3 10 10 10 22 10 26 10;
createNode animCurveTA -n "FKRoot_M_rotateX";
	rename -uid "F41F1905-4A6B-787F-F646-B38A4F9926DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKRoot_M_rotateY";
	rename -uid "BBBF33DA-4E0B-D5E9-3709-28A163192B26";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKRoot_M_rotateZ";
	rename -uid "77F170CA-4F7B-B766-5DF7-288ADD254181";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 14.736202721112454 3 0 9 0 14 0 16 0 22 0
		 26 14.736202721112454;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateX";
	rename -uid "925849F1-4F4B-B642-79E4-0BB9D3A052EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateY";
	rename -uid "1CC8F001-438C-2D14-62FB-BD8F49410C27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateZ";
	rename -uid "7DD9656C-49DF-6F39-D430-968C1FFB2909";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "RollToesEnd_L_visibility";
	rename -uid "62D866F3-430E-9E61-4B43-6A9AFCE465ED";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTA -n "RollToesEnd_L_rotateX";
	rename -uid "82EB97C2-4667-EAB9-5F65-20ABC29F2084";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToesEnd_L_rotateY";
	rename -uid "7DA5C4C9-43B2-B1F2-EA19-C0B81395EC05";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToesEnd_L_rotateZ";
	rename -uid "1EBD5D19-459D-CFFF-C2CA-D28D14C14361";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTU -n "RollToesEnd_L_scaleX";
	rename -uid "752DD37E-49A8-18B1-211A-ADAF9D464ADB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToesEnd_L_scaleY";
	rename -uid "707F053B-423B-6CC2-EE1E-A0BF07C61E2A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToesEnd_L_scaleZ";
	rename -uid "728B2427-4D97-DB14-BABD-72BEB5ECB08A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "Fingers_R_indexCurl";
	rename -uid "AA02CD41-4AA9-1A5C-DCFA-7A880705C836";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -2 9 0 14 0 16 0 22 0 26 -2;
createNode animCurveTU -n "Fingers_R_middleCurl";
	rename -uid "4F5C9241-48CA-FCC1-F947-12AB13D872A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -1.2000000476837158 9 0 14 0 16 0 22 0
		 26 -1.2000000476837158;
createNode animCurveTU -n "Fingers_R_pinkyCurl";
	rename -uid "63F40979-44D3-DEB0-220A-B08B0C7EADBC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0.40000003576278687 9 0 14 0 16 0 22 0
		 26 0.40000003576278687;
createNode animCurveTU -n "Fingers_R_thumbCurl";
	rename -uid "31D63C50-45FC-33C1-B07E-81880A0AA21A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -2 9 0 14 0 16 0 22 0 26 -2;
createNode animCurveTU -n "Fingers_R_spread";
	rename -uid "D494D205-48CB-5094-4BC1-8A9E6455AC52";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1.8999999761581421 9 0 14 0 16 0 22 0
		 26 1.8999999761581421;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateX";
	rename -uid "EF31B119-4CA3-0586-6BAA-31A75836E722";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateY";
	rename -uid "97F887CF-4EEA-39CF-A837-D18D7EE55D24";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateZ";
	rename -uid "200FB5E3-4BEE-A797-FEAB-BCAEF6D7506B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger2_L_rotateX";
	rename -uid "0210FC27-4727-EAA5-41A4-C0B5787BC6EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger2_L_rotateY";
	rename -uid "9FB0A8BA-4F74-0535-4366-4C991BE2C42E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger2_L_rotateZ";
	rename -uid "7A59F5F0-494F-558B-F9DB-81AE58C1363D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "RollToesEnd_R_visibility";
	rename -uid "1DD3CE08-466A-A47A-25D3-C2997312801C";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTA -n "RollToesEnd_R_rotateX";
	rename -uid "FAB21B5B-44E3-A283-77F9-CF837028410A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToesEnd_R_rotateY";
	rename -uid "8D345B78-436C-EF22-C4F6-07A6648849DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollToesEnd_R_rotateZ";
	rename -uid "2A9BC31F-4A26-3E33-6C26-BAB47B386EE2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTU -n "RollToesEnd_R_scaleX";
	rename -uid "E08E771F-4420-A888-BE5B-93807CFF86BE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToesEnd_R_scaleY";
	rename -uid "9BCF7838-4B5E-4305-4946-159FDE7927BE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollToesEnd_R_scaleZ";
	rename -uid "BF628370-44B0-466B-B12F-98BDD3874D39";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTA -n "FKIndexFinger2_R_rotateX";
	rename -uid "5CC5D80E-4241-85AA-488E-4EA6BA770FA6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger2_R_rotateY";
	rename -uid "5BE41F0E-4F35-E63E-28BA-8BB7AF1F424B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger2_R_rotateZ";
	rename -uid "711F9CC1-447D-53C7-E400-F2BC7CF4FF04";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKShoulder_L_rotateX";
	rename -uid "3A84918B-48C9-28EA-B3DC-6382BEBE4EB2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 19.253675154181213 3 -1.5217964863726436
		 9 0 14 0 16 0 22 0 26 19.253675154181213;
createNode animCurveTA -n "FKShoulder_L_rotateY";
	rename -uid "6BBF3D1D-49C4-EFDE-9302-EDA31E81429A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 6.8683553226509577 3 19.599702788791046
		 9 0 14 0 16 0 22 0 26 6.8683553226509577;
createNode animCurveTA -n "FKShoulder_L_rotateZ";
	rename -uid "718830BC-44F5-E792-CAF4-B9B3A5FF657B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 2.5176365764109776 3 4.1694817845352228
		 9 0 14 0 16 0 22 0 26 2.5176365764109776;
createNode animCurveTU -n "FKIKLeg_R_FKIKBlend";
	rename -uid "5F4011AD-4463-E8FE-3BB3-58BA4A398D97";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  1 10 3 10 5 0 9 0 14 0 16 0 22 0 26 10;
createNode animCurveTU -n "FKIKLeg_R_FKVis";
	rename -uid "A95CAEDC-40D3-1762-8B5D-4DBB6CBB2018";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 1 5 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 7 ".kot[0:6]"  5 5 5 5 5 5 5;
createNode animCurveTU -n "FKIKLeg_R_IKVis";
	rename -uid "5DB92F4D-419A-02B5-34AE-0C901D3DD2D6";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 1 5 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 7 ".kot[0:6]"  5 5 5 5 5 5 5;
createNode animCurveTA -n "FKIndexFinger1_R_rotateX";
	rename -uid "1F98C179-4179-28FB-7AC1-BDBB2EECDC16";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger1_R_rotateY";
	rename -uid "89F0A6C5-42D2-204E-8BB0-E88D8B3319F6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger1_R_rotateZ";
	rename -uid "62EDB6B5-4173-4A86-3E2E-D38F1E7DD473";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKShoulder1_L_rotateX";
	rename -uid "81390AAF-4F29-619C-2256-EEB8E60F4633";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 90.782454070358199 3 3.7231748360904406
		 9 -0.50830015238847059 14 -0.50830015238847059 16 -0.50830015238847059 22 -0.50830015238847059
		 26 90.782454070358199;
createNode animCurveTA -n "FKShoulder1_L_rotateY";
	rename -uid "A66119BA-4EAB-3DEB-DCB2-CB9107C89C7F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 15.056378402153957 3 60.459437439246003
		 9 12.862877478589308 14 12.862877478589308 16 12.862877478589308 22 12.862877478589308
		 26 15.056378402153957;
createNode animCurveTA -n "FKShoulder1_L_rotateZ";
	rename -uid "6CEA2627-415A-42F3-2C02-02AAC3DB0882";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 101.23463125198822 3 12.140816337581496
		 9 -29.444255377568087 14 -29.444255377568087 16 -29.444255377568087 22 -29.444255377568087
		 26 101.23463125198822;
createNode animCurveTU -n "FKIKArm_L_FKIKBlend";
	rename -uid "3B4EABB1-4E37-80C4-DC37-04A429B3D80D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "FKIKArm_L_FKVis";
	rename -uid "F63E4CC5-4CA0-1F68-C96E-758667EE0FA1";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTU -n "FKIKArm_L_IKVis";
	rename -uid "598CF863-4937-FAF4-B581-CA9BA6863300";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTA -n "pairBlend1_inRotateX1";
	rename -uid "06594547-4FE0-BE68-4043-D78105F264E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 60.728925002333661 10 5.8402760606131547
		 16 5.8402760606131547 20 5.8402760606131547 26 5.8402760606131547 30 60.728925002333661;
createNode animCurveTA -n "pairBlend1_inRotateY1";
	rename -uid "64490BBC-464E-00A9-E984-309EC403D577";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -5.1283917837244033 10 53.454796740257351
		 16 53.454796740257351 20 53.454796740257351 26 53.454796740257351 30 -5.1283917837244033;
createNode animCurveTA -n "pairBlend1_inRotateZ1";
	rename -uid "4800ACE2-428C-515F-7998-F8A3E9D87892";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -23.567606618096431 10 1.619253498084771
		 16 1.619253498084771 20 1.619253498084771 26 1.619253498084771 30 -23.567606618096431;
createNode animCurveTU -n "Collar_Ctrl_Master_blendParent1";
	rename -uid "85E39251-48C6-2BBD-EE22-21A13977E9B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 10 0 16 0 20 0 26 0 30 0;
createNode animCurveTA -n "Gorro_Ctrl_rotateX";
	rename -uid "5843EEB2-4502-134D-822D-299FFD037782";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Gorro_Ctrl_rotateY";
	rename -uid "43CA62EA-4105-92D1-AE66-05B7EBEF5741";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Gorro_Ctrl_rotateZ";
	rename -uid "DFF695E1-44D4-F715-4561-DA861D4EA787";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "IKLeg_R_rotateX";
	rename -uid "A1B79021-4CBF-0806-27CE-6BADA845FEC3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 129.91838225596146 22 129.91838225596146
		 26 0;
createNode animCurveTA -n "IKLeg_R_rotateY";
	rename -uid "82E07650-47C4-91E9-F200-C6B44BE2369B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 6.2432369458441972 3 6.2432369458441972
		 10 0 22 0 26 6.2432369458441972;
createNode animCurveTA -n "IKLeg_R_rotateZ";
	rename -uid "C9F2F875-4181-8BAD-96A5-1CB9C41A2745";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_R_toe";
	rename -uid "47D6D3A8-4370-522B-2ACD-09AE0A225707";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_R_roll";
	rename -uid "E8E70730-43C0-5E76-7F09-4F9AAF7398A0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_R_rollAngle";
	rename -uid "402D57BD-47C9-DA66-2670-7987A4699B7C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 25 3 25 10 25 22 25 26 25;
createNode animCurveTU -n "IKLeg_R_stretchy";
	rename -uid "DA646D58-4B71-5AE8-2A83-91B380A10C54";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_R_antiPop";
	rename -uid "B0BF022B-405C-009C-A5D3-09BAC0693234";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 3 0 10 0 22 0 26 0;
createNode animCurveTU -n "IKLeg_R_Lenght1";
	rename -uid "1A8CF0C8-4BAE-FA54-0691-38B21571E68D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1 3 1 10 1.25 22 1.25 26 1;
createNode animCurveTU -n "IKLeg_R_Lenght2";
	rename -uid "04348547-437A-C15C-863D-4D969C855CEC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1 3 1 10 1.25 22 1.25 26 1;
createNode animCurveTU -n "IKLeg_R_volume";
	rename -uid "C2D4F279-45F9-2558-DB02-D8A2D2E74914";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 10 3 10 10 10 22 10 26 10;
createNode animCurveTA -n "FKThumbFinger2_R_rotateX";
	rename -uid "869D2396-4D1A-BB53-A637-B59CB857D77F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger2_R_rotateY";
	rename -uid "E1867927-444D-5419-6BB0-9FBD067E3BA9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger2_R_rotateZ";
	rename -uid "C73164AD-4775-C673-187E-DD8AC436C483";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateX";
	rename -uid "ADA469DF-4FB4-30F4-170C-97A99BBA42C6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateY";
	rename -uid "51D46184-4391-1480-CCBA-538CE291D404";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateZ";
	rename -uid "A8A0AE21-410A-B41D-09D7-A9A0B27C2096";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateX";
	rename -uid "62B27378-4E4F-BF41-0F8A-3983B457CB43";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateY";
	rename -uid "B3D476F1-4F00-0D78-0E80-E0890312CDBE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateZ";
	rename -uid "C8E24D5F-4AEF-C631-3B5B-7D9C6CA85295";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKWrist_R_rotateX";
	rename -uid "84EAC48B-40AA-A13D-074B-9AAE07F6110F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -5.7924777679870774 3 0 9 0 14 0 16 0
		 22 0 26 -5.7924777679870774;
createNode animCurveTA -n "FKWrist_R_rotateY";
	rename -uid "59780287-4EDE-7968-BC62-B3B6472694BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -4.4001830051398327 3 13.278885063237077
		 9 0 14 0 16 0 22 0 26 -4.4001830051398327;
createNode animCurveTA -n "FKWrist_R_rotateZ";
	rename -uid "8F18310F-41CB-BCBA-D910-419795A37FDF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 21.290586712836664 3 0 9 25.628250200723027
		 14 25.628250200723027 16 25.628250200723027 22 25.628250200723027 26 21.290586712836664;
createNode animCurveTU -n "FKIKSpine_M_FKIKBlend";
	rename -uid "7772E1C4-4890-3A2A-E76B-EBBC65CB2257";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "FKIKSpine_M_FKVis";
	rename -uid "CB0CBAAC-4803-7A63-9B40-AD9B4B9E2F43";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTU -n "FKIKSpine_M_IKVis";
	rename -uid "529C7116-43FA-75BB-2488-D2B60351E62C";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTU -n "Bigote02_Ctrl_visibility";
	rename -uid "D8D41A9F-4454-F53A-8748-EDB4BA2CD091";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 6 ".kot[0:5]"  5 5 5 5 5 5;
createNode animCurveTA -n "Bigote02_Ctrl_rotateX";
	rename -uid "6A1F292C-40E3-6290-416C-BAA0D13FDD1F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Bigote02_Ctrl_rotateY";
	rename -uid "C78353CE-4191-0771-941C-688154D33E4E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "Bigote02_Ctrl_rotateZ";
	rename -uid "9E9ACAD0-42B3-99B8-AD0A-2DADBCFAFF3D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "Bigote02_Ctrl_scaleX";
	rename -uid "D967C74D-4EB4-6131-B747-7897B802C144";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTU -n "Bigote02_Ctrl_scaleY";
	rename -uid "F6C75797-48E7-9384-3558-6CA4FA0C1002";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTU -n "Bigote02_Ctrl_scaleZ";
	rename -uid "1EB1D1D6-4F36-9FB1-ED5E-AC8EFA0D53A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1 9 1 14 1 16 1 22 1 26 1;
createNode animCurveTU -n "Fingers_L_indexCurl";
	rename -uid "FC73C7EE-4BD0-8F08-A752-7BB4B5978CDE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -2 9 0 14 0 16 0 22 0 26 -2;
createNode animCurveTU -n "Fingers_L_middleCurl";
	rename -uid "3F37E99E-47E4-114D-773F-208E3B8BE5BA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 1.2000000476837158 9 0 14 0 16 0 22 0
		 26 1.2000000476837158;
createNode animCurveTU -n "Fingers_L_pinkyCurl";
	rename -uid "95C0EE77-48A4-78D1-7826-058A6DDAF76D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 2 9 0 14 0 16 0 22 0 26 2;
createNode animCurveTU -n "Fingers_L_thumbCurl";
	rename -uid "94FD17A7-4697-1301-80F2-D5BBE2423DA3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 2.5 9 0 14 0 16 0 22 0 26 2.5;
createNode animCurveTU -n "Fingers_L_spread";
	rename -uid "72B13F2F-4812-DBB4-CF35-2EA82AF3C898";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0.10000000149011612 9 0 14 0 16 0 22 0
		 26 0.10000000149011612;
createNode animCurveTU -n "RollHeel_L_visibility";
	rename -uid "335F68BB-41B2-0CB1-9C28-B2B9B7170EB5";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTA -n "RollHeel_L_rotateX";
	rename -uid "7B2F8DCC-4B24-F090-F9B2-D8948FC26480";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollHeel_L_rotateY";
	rename -uid "AAA1F8FB-41D8-D7BC-A0A0-239CF5978103";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollHeel_L_rotateZ";
	rename -uid "4CCABE40-4457-0E3E-0C6F-E9B04D06458A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTU -n "RollHeel_L_scaleX";
	rename -uid "09B28489-40ED-F942-3043-188F67CF9972";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollHeel_L_scaleY";
	rename -uid "8C5E5581-46F5-E786-6B7A-F289A549DCD4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollHeel_L_scaleZ";
	rename -uid "2AA06D72-4DEF-ADC4-4F7C-CFBF8FD7FEAE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateX";
	rename -uid "EC9F0642-498E-8C19-4D38-AB803AA900CF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateY";
	rename -uid "B831AA58-46CF-E258-D138-FE990438BB08";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateZ";
	rename -uid "F1624755-4B11-4D5B-E1A0-A09EE3E5C6A2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger1_L_rotateX";
	rename -uid "FCC6FFB9-413B-5E7D-24BF-C3894B000837";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger1_L_rotateY";
	rename -uid "D66F50BD-4C0B-B13C-3528-FEA076AE7F63";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger1_L_rotateZ";
	rename -uid "860250F6-4EB3-2595-EF89-3BA88802676E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKElbow1_R_rotateX";
	rename -uid "E8CB7AAD-486E-73F2-6C6B-41ABF631C3D4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 2.1697266848827139 3 0 9 0 14 0 16 0 22 0
		 26 2.1697266848827139;
createNode animCurveTA -n "FKElbow1_R_rotateY";
	rename -uid "7257293C-424E-5675-96B2-58990C6BBC35";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 9.5451742293401018 3 1.555218840988972
		 9 0 14 0 16 0 22 0 26 9.5451742293401018;
createNode animCurveTA -n "FKElbow1_R_rotateZ";
	rename -uid "067B5F2C-4D82-FE98-7D0C-DBA4C75C0F54";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 19.637773848936135 3 0 9 65.278186403713065
		 14 65.278186403713065 16 65.278186403713065 22 65.278186403713065 26 19.637773848936135;
createNode animCurveTU -n "FKSpine1_M_uiTreatment";
	rename -uid "012FA421-46DD-E84C-A681-45802F1C4042";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 0 14 0 16 0 22 0 26 0;
	setAttr -s 7 ".kot[0:6]"  5 5 5 5 5 5 5;
createNode animCurveTA -n "FKSpine1_M_rotateX";
	rename -uid "165DFB33-4857-CBA0-E443-799D0A9B0117";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 24.303859507239359 14 24.303859507239359
		 16 24.303859507239359 22 24.303859507239359 26 0;
createNode animCurveTA -n "FKSpine1_M_rotateY";
	rename -uid "BD2F6783-4781-DBF6-E73C-9198A3E90C11";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0 9 -18.502495980623966 14 -18.502495980623966
		 16 -18.502495980623966 22 -18.502495980623966 26 0;
createNode animCurveTA -n "FKSpine1_M_rotateZ";
	rename -uid "459F0988-450F-DD31-9B34-A7BCC568FD2C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 14.736202721112454 3 0 9 3.443323615921221
		 14 3.443323615921221 16 3.443323615921221 22 3.443323615921221 26 14.736202721112454;
createNode animCurveTU -n "PoleLeg_R_follow";
	rename -uid "AD7FEB0F-488D-C8DA-5C26-4C97794961B5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 10 10 10 26 10 30 10;
createNode animCurveTU -n "PoleLeg_R_lock";
	rename -uid "E7F8D77F-4A3E-6A55-9267-93BF25A24AF6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "FKThumbFinger2_L_rotateX";
	rename -uid "A054C592-42DF-34DC-9AC9-FB9446E0DF94";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger2_L_rotateY";
	rename -uid "F3E42482-4D2E-AD30-D829-7BA09508836F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger2_L_rotateZ";
	rename -uid "DE569876-4F0F-9BCF-E2E7-529CC6D9BB3E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKElbow_L_rotateX";
	rename -uid "4471BBBB-4294-A744-06C7-1CADA54DA265";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -351.66867947203252 3 0 9 1.1850099885472838
		 14 1.1850099885472838 16 1.1850099885472838 22 1.1850099885472838 26 -351.66867947203252;
createNode animCurveTA -n "FKElbow_L_rotateY";
	rename -uid "137FB78C-436E-6A5C-A9B2-8CAE97364B15";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -6.6327048761791119 3 10.375506723444072
		 9 12.833541283964657 14 12.833541283964657 16 12.833541283964657 22 12.833541283964657
		 26 -6.6327048761791119;
createNode animCurveTA -n "FKElbow_L_rotateZ";
	rename -uid "462729BD-4CBB-3E32-B632-208EA9D8C619";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 395.8559491856858 3 0 9 -7.5140825349800977
		 14 -7.5140825349800977 16 -7.5140825349800977 22 -7.5140825349800977 26 395.8559491856858;
createNode animCurveTA -n "HipSwinger_M_rotateX";
	rename -uid "AFC0BF23-4AFC-18E6-64A5-B1B9EFCC6AB2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 5.8916923802663916 9 -71.989800332473081
		 14 -71.989800332473081 16 -71.989800332473081 22 -71.989800332473081 26 5.8916923802663916;
createNode animCurveTA -n "HipSwinger_M_rotateY";
	rename -uid "0B1E9149-4D86-D6AE-65F4-328B7A8B3D8B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -3.4146402246274676 9 -3.0390808060350936
		 14 -3.0390808060350936 16 -3.0390808060350936 22 -3.0390808060350936 26 -3.4146402246274676;
createNode animCurveTA -n "HipSwinger_M_rotateZ";
	rename -uid "CE08E122-4B36-F706-3497-9C895A11A415";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -17.372289138868627 9 -0.52005538448785071
		 14 -0.52005538448785071 16 -0.52005538448785071 22 -0.52005538448785071 26 -17.372289138868627;
createNode animCurveTU -n "HipSwinger_M_stabilize";
	rename -uid "9B2B1508-4F25-94F3-E3BF-43887BCFAC77";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 10 9 10 14 10 16 10 22 10 26 10;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateX";
	rename -uid "69C7AB2D-4A73-0B90-2DEE-B782BD891EAA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateY";
	rename -uid "B59D6DE4-4F30-6BB6-7EA6-B684693ED297";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateZ";
	rename -uid "E352E0C8-4E57-371C-2DF6-5E89EFEFE834";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKWrist_L_rotateX";
	rename -uid "77B0BAF8-4946-539D-C173-0D8C98C40B8C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -364.2127843464246 3 0 9 1.7545909106267954
		 14 1.7545909106267954 16 1.7545909106267954 22 1.7545909106267954 26 -364.2127843464246;
createNode animCurveTA -n "FKWrist_L_rotateY";
	rename -uid "6B90CD7A-4769-D0C2-02DA-3F913EB83A12";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 2.531157201175473 3 0 9 12.769221607485168
		 14 12.769221607485168 16 12.769221607485168 22 12.769221607485168 26 2.531157201175473;
createNode animCurveTA -n "FKWrist_L_rotateZ";
	rename -uid "24BB942C-41DE-EC1F-6770-7DA160EC343F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 397.49608592277622 3 0 9 -10.084307927403929
		 14 -10.084307927403929 16 -10.084307927403929 22 -10.084307927403929 26 397.49608592277622;
createNode animCurveTA -n "RootX_M_rotateX";
	rename -uid "A1C3B9CE-46B1-3465-1E90-7B82FDF03E0B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 19.230084093337425 3 11.108948488779109
		 9 0 14 0 16 0 22 0 26 19.230084093337425;
createNode animCurveTA -n "RootX_M_rotateY";
	rename -uid "7E573A0F-4D5E-FFF6-9383-E39D94FC345D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 0.35660920875369406 9 0 14 -367.5862569815896
		 16 -367.5862569815896 22 -735.46466134986247 26 0;
createNode animCurveTA -n "RootX_M_rotateZ";
	rename -uid "7B28177B-4FE6-B65A-AA07-8ABD23597369";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 0 3 3.578740249500473 9 28.497884221777237
		 14 28.497884221777237 16 28.497884221777237 22 28.497884221777234 26 0;
createNode animCurveTU -n "RootX_M_legLock";
	rename -uid "0C6218C1-48FB-4B47-4D3B-40A91F2DBA3E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "RootX_M_CenterBtwFeet";
	rename -uid "7D6F260C-49A3-E291-30CC-5597068DBD78";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateX";
	rename -uid "A0F285CD-464C-D82C-9F93-CDB864532CC4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateY";
	rename -uid "C4EBFBCE-4C02-4959-44F7-F195A1B3EA81";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateZ";
	rename -uid "E3717EE9-4A87-6D01-567F-59BA2BBEED81";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateX";
	rename -uid "3B3DCE99-4051-464A-7625-06A8E678B5B3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateY";
	rename -uid "57D5F715-4C48-AADF-CDB3-71A56DECC46F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateZ";
	rename -uid "8AD95D74-4A64-0B2B-DE1B-F494EEAB2888";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateX";
	rename -uid "A8E83B63-4E0F-A8CD-CB80-1CA20343FDBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateY";
	rename -uid "B994BE81-4CA1-B399-B4A1-D5B2B5F62F0C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateZ";
	rename -uid "63B2348C-49C1-EA42-58DA-FC88232EA38E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKToes_R_rotateX";
	rename -uid "BD4B2D71-4273-78F3-AA69-9BA1ADEEBF1D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKToes_R_rotateY";
	rename -uid "182FCD91-4E96-A3AB-7103-AFB724C7ED2D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKToes_R_rotateZ";
	rename -uid "89BA30C4-4179-DF4E-AE29-30A15FC7F14C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateX";
	rename -uid "C800DD1D-477A-D8BD-C160-60933273F328";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateY";
	rename -uid "ABF286EE-4676-F75D-5AD4-A3838DDA0D86";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateZ";
	rename -uid "E358C8F1-4C94-8753-822F-C19213A8B772";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKElbow_R_rotateX";
	rename -uid "9D45ACC4-4C40-D3D4-2CC6-A9A72A7AE7AF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -0.4176958471533545 3 0 9 0 14 0 16 0
		 22 0 26 -0.4176958471533545;
createNode animCurveTA -n "FKElbow_R_rotateY";
	rename -uid "EDE9FAF7-4517-9961-1638-EF80E93588CE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 10.202813519593809 3 19.820995611571181
		 9 0 14 0 16 0 22 0 26 10.202813519593809;
createNode animCurveTA -n "FKElbow_R_rotateZ";
	rename -uid "AC5F8F64-4D50-A832-197B-C89489B2D9BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 9.3044003866788643 3 0 9 31.08255048373174
		 14 31.08255048373174 16 31.08255048373174 22 31.08255048373174 26 9.3044003866788643;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateX";
	rename -uid "75D8F755-4C00-FDEA-4105-B79401988C15";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateY";
	rename -uid "BFCD4C50-4818-2928-0789-C9BD0DAB6856";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateZ";
	rename -uid "59993D46-41DB-8474-FCA1-069E3ED8EEC1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger3_L_rotateX";
	rename -uid "6CFA4E3A-4298-C172-6AB4-04A43520678B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger3_L_rotateY";
	rename -uid "11283DC1-4638-7373-C63B-42A09084D662";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKThumbFinger3_L_rotateZ";
	rename -uid "7EFA4780-4136-B7B0-5527-E0AE78989340";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKHead_M_rotateX";
	rename -uid "618C1488-4FB6-CB05-1E30-069A65FB65C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 13.315022769214799 3 0 9 0 14 0 16 0 22 0
		 26 13.315022769214799;
createNode animCurveTA -n "FKHead_M_rotateY";
	rename -uid "F7D63443-4210-FEB2-FC4C-DF8ECD3FF3A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 22.788243816487746 3 0 9 0 14 0 16 0 22 0
		 26 22.788243816487746;
createNode animCurveTA -n "FKHead_M_rotateZ";
	rename -uid "22F35CFA-485F-831A-28B1-8995D27C83CE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 -27.665429398992121 3 0 9 0 14 0 16 0
		 22 0 26 -27.665429398992121;
createNode animCurveTU -n "RollHeel_R_visibility";
	rename -uid "E38ADE41-464E-7E24-CC1E-0BBB0BBC57C7";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTA -n "RollHeel_R_rotateX";
	rename -uid "6E4EF750-4858-46B6-6D9A-A89354B8B67B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollHeel_R_rotateY";
	rename -uid "E570077C-4521-1455-A28B-8E876A478983";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTA -n "RollHeel_R_rotateZ";
	rename -uid "7BD6CB70-4344-DCEB-1273-FABCA78A92AF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 10 0 26 0 30 0;
createNode animCurveTU -n "RollHeel_R_scaleX";
	rename -uid "1ACE472F-4843-0077-C6E2-24B504A90478";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollHeel_R_scaleY";
	rename -uid "181C1433-490B-445A-1561-65A955188207";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "RollHeel_R_scaleZ";
	rename -uid "0660609E-4E74-B234-AE3F-E8B88EF0D976";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 10 1 26 1 30 1;
createNode animCurveTU -n "FKIKLeg_L_FKVis";
	rename -uid "4602FF9C-4883-EB8C-4877-4B8D48E11298";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 1 5 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 7 ".kot[0:6]"  5 5 5 5 5 5 5;
createNode animCurveTU -n "FKIKLeg_L_IKVis";
	rename -uid "7F2B5CA9-4AED-195B-420F-EA9A3AAF4F23";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  1 1 5 1 9 1 14 1 16 1 22 1 26 1;
	setAttr -s 7 ".kot[0:6]"  5 5 5 5 5 5 5;
createNode animCurveTA -n "FKIndexFinger3_R_rotateX";
	rename -uid "5C3EEDA8-4E85-40E1-F5B9-D29A54A70E2A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger3_R_rotateY";
	rename -uid "316D6991-407D-8701-5211-EDA06DD8FCD0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger3_R_rotateZ";
	rename -uid "31DC19BD-4E77-4795-A9E4-DDB8FF4C4A65";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger3_L_rotateX";
	rename -uid "18F74FFB-490C-B6D2-BFBC-3F89F6A6293A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger3_L_rotateY";
	rename -uid "66D12BB2-4601-05DB-ED45-66A7AB30E934";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTA -n "FKIndexFinger3_L_rotateZ";
	rename -uid "836DE0E3-4D92-8B49-6BA4-C6B43E243CFB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 0 9 0 14 0 16 0 22 0 26 0;
createNode animCurveTU -n "FKIKLeg_L_FKIKBlend";
	rename -uid "B036AA1F-4FCC-DB76-02C3-73900C6037C4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  1 10 3 10 5 0 9 0 14 0 16 0 22 0 26 10;
createNode animCurveTA -n "FKHip_L_rotateX";
	rename -uid "D83B66E6-461A-7437-08B3-BC85963C2D46";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 51.456759888210541 5 76.226723930760414
		 9 76.226723930760414 14 76.226723930760414 16 76.226723930760414;
createNode animCurveTA -n "FKHip_L_rotateY";
	rename -uid "26317008-495D-8901-D61D-BB97E060DA62";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 89.031941019107677 5 16.061153445577325
		 9 16.061153445577325 14 16.061153445577325 16 16.061153445577325;
createNode animCurveTA -n "FKHip_L_rotateZ";
	rename -uid "F82AE916-4BBD-AF36-4939-2F920707B1CD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 157.8918357111697 5 73.49350204417118
		 9 91.616422878914278 14 91.616422878914278 16 91.616422878914278;
createNode animCurveTA -n "FKKnee_L_rotateX";
	rename -uid "79AA16CB-4650-C550-1D39-769A5B2C6E5D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1.0485992781038389e-14 7 0 9 0 14 0 16 0;
createNode animCurveTA -n "FKKnee_L_rotateY";
	rename -uid "712E82ED-4449-518B-5BF4-9CB200C0A159";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 -1.1955841979572079e-14 7 0 9 0 14 0 16 0;
createNode animCurveTA -n "FKKnee_L_rotateZ";
	rename -uid "04545341-4901-42D1-0EE5-3088607B5262";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 8.7656264549474976 5 -112.66663978288175
		 7 -154.78572767450063 9 -154.78572767450063 14 0 16 0;
createNode animCurveTA -n "FKAnkle_L_rotateX";
	rename -uid "78AEDCA3-402B-6E9B-4EED-31879B030AC4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 -5.3007314087760706 9 0 14 0 16 0;
createNode animCurveTA -n "FKAnkle_L_rotateY";
	rename -uid "9CADD607-4206-F324-46B0-93905F18C45D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 -12.571738205346172 9 0 14 0 16 0;
createNode animCurveTA -n "FKAnkle_L_rotateZ";
	rename -uid "2B03FFE8-4F86-0C7E-77B5-32B7D17DB416";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 -30.426629835436554 9 0 14 0 16 0;
createNode animCurveTA -n "FKHip_R_rotateX";
	rename -uid "8BE623EB-49ED-76F2-89FE-F19D334D5A42";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 5 47.78377392630653 9 61.568054090728367
		 14 0 16 0;
createNode animCurveTA -n "FKHip_R_rotateY";
	rename -uid "4842DE9C-401E-2422-098D-4194C931E727";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 -96.427587127374593 5 -20.750159223626817
		 9 -47.482620912635156 14 -96.427587127374593 16 -96.427587127374593;
createNode animCurveTA -n "FKHip_R_rotateZ";
	rename -uid "19D8F1DF-4C59-DC59-3D2D-E5A3DB11EC22";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 5 23.559023428776268 9 78.333153692555953
		 14 0 16 0;
createNode animCurveTA -n "FKKnee_R_rotateX";
	rename -uid "9F675CD2-44BE-50FE-4BF2-3AAAEE7FD179";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTA -n "FKKnee_R_rotateY";
	rename -uid "725F3B86-456A-EA57-AAA2-7583502F4B1C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTA -n "FKKnee_R_rotateZ";
	rename -uid "89FA2821-44BE-71AC-96FE-92AA59F06BFC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 0 5 -80.389321737656232 9 -147.17772548740282
		 14 0 16 0;
createNode animCurveTA -n "FKAnkle_R_rotateX";
	rename -uid "32433951-431C-2811-3E94-1AB74B3B4401";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTA -n "FKAnkle_R_rotateY";
	rename -uid "3C2A2934-430F-264B-343A-3DBA3D441B53";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTA -n "FKAnkle_R_rotateZ";
	rename -uid "106AEB9C-4656-8AC4-DC22-04B6BE78FABE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTU -n "FKKnee_L_visibility";
	rename -uid "F7CFC462-48C1-48D2-D164-E5B11DD30F5F";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1 7 1 9 1 14 1 16 1;
	setAttr -s 5 ".kot[0:4]"  5 5 5 5 5;
createNode animCurveTL -n "FKKnee_L_translateX";
	rename -uid "191F28F3-4048-751E-216C-31954CEEA733";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -2.0369945249038341 5 0 7 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKKnee_L_translateY";
	rename -uid "2060102E-4604-540E-5F6D-E19EBFAC6662";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  1 -0.31409401486340371 5 0 7 0 9 0 14 0
		 16 0;
createNode animCurveTL -n "FKKnee_L_translateZ";
	rename -uid "E004271A-4B4E-B932-9AE0-1A9566B380F6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 -6.6613381477509392e-15 7 -6.6613381477509392e-15
		 9 0 14 0 16 0;
createNode animCurveTU -n "FKKnee_L_scaleX";
	rename -uid "28381625-4C2E-57B4-B382-BD9F085723F8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1.0000000000000002 7 1.0000000000000002
		 9 1.0000000000000002 14 1.0000000000000002 16 1.0000000000000002;
createNode animCurveTU -n "FKKnee_L_scaleY";
	rename -uid "DB558864-4ED2-C242-1BFD-4A901BA9BD41";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1.0000000000000004 7 1.0000000000000004
		 9 1.0000000000000004 14 1.0000000000000004 16 1.0000000000000004;
createNode animCurveTU -n "FKKnee_L_scaleZ";
	rename -uid "B6E9FC4E-4A7B-10C7-3B1C-99BE061ABF37";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  1 1.0000000000000004 7 1.0000000000000004
		 9 1.0000000000000004 14 1.0000000000000004 16 1.0000000000000004;
createNode animCurveTU -n "FKAnkle_R_visibility";
	rename -uid "5D246D87-48D0-F30E-D419-FE8E1745BA5A";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTL -n "FKAnkle_R_translateX";
	rename -uid "9CAFE609-4B5F-229C-C060-2F95D114CB20";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKAnkle_R_translateY";
	rename -uid "67D8D0FD-4B09-608F-D48C-90ADEDC18F28";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKAnkle_R_translateZ";
	rename -uid "C17A11C1-4B64-659C-8138-B1BAB74DE55F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTU -n "FKAnkle_R_scaleX";
	rename -uid "C9520941-41C6-5CB9-D514-60A133AC862D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKAnkle_R_scaleY";
	rename -uid "48DB1ADD-41C0-1481-9CDC-8C8077784B44";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKAnkle_R_scaleZ";
	rename -uid "EA9B2967-4C64-598E-F062-439BD6522842";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKHip_L_visibility";
	rename -uid "3FC86E64-4D46-C2B0-C8A1-A68065E30705";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTL -n "FKHip_L_translateX";
	rename -uid "BC0371DC-4FD8-6BC9-272B-6AA395FA72BA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKHip_L_translateY";
	rename -uid "C532E66A-41E6-9052-87E7-EEB0994C321B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKHip_L_translateZ";
	rename -uid "14694B96-467F-0A49-FFD8-59ABA0797C17";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTU -n "FKHip_L_scaleX";
	rename -uid "4A5A6199-4B71-E48C-93B9-2ABB011180A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0.99999999999999978 9 0.99999999999999978
		 14 0.99999999999999978 16 0.99999999999999978;
createNode animCurveTU -n "FKHip_L_scaleY";
	rename -uid "919D4386-4E63-2B3B-40D7-E78E2739BDA5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKHip_L_scaleZ";
	rename -uid "822BDE7A-413E-4A7F-37C5-C680A079281A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKHip_R_visibility";
	rename -uid "D447DBEC-4F9E-0427-4B1D-E6BB1320CF33";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTL -n "FKHip_R_translateX";
	rename -uid "5F33368D-4CCA-00B9-0853-D1B64B9BA852";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKHip_R_translateY";
	rename -uid "21B3EFB7-4ED2-BF90-844E-2CBB00521359";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKHip_R_translateZ";
	rename -uid "605E16E4-45E5-1313-85AB-0295FD5BD7BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTU -n "FKHip_R_scaleX";
	rename -uid "61E42532-477D-6329-36C3-D09ADF65FD80";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKHip_R_scaleY";
	rename -uid "231B4A9E-4673-1C6B-3528-C993F1045EA2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKHip_R_scaleZ";
	rename -uid "41B9E773-45E9-396C-8B78-5AB329928076";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKKnee_R_visibility";
	rename -uid "F90D210E-437A-5DFF-CC76-97A4DC22BED6";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTL -n "FKKnee_R_translateX";
	rename -uid "FE3E197A-4154-3FB6-A411-04A12569AB4E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKKnee_R_translateY";
	rename -uid "0DCE39C8-413F-F4A3-CF96-06B12AA0C5BE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTL -n "FKKnee_R_translateZ";
	rename -uid "7C4A4427-48B6-74C6-C9B5-EBBFFAAB285B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0 9 0 14 0 16 0;
createNode animCurveTU -n "FKKnee_R_scaleX";
	rename -uid "57AE303A-46DE-7C8C-5CE2-8CB5570A49FC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKKnee_R_scaleY";
	rename -uid "86DC5109-4E53-E5ED-05BA-7BA6D70B3E01";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKKnee_R_scaleZ";
	rename -uid "04C826DA-4E20-7D8D-00E4-D99507D38DD0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKAnkle_L_visibility";
	rename -uid "B05F3735-4BD8-51B9-6A7A-02A11E51FC60";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
	setAttr -s 4 ".kot[0:3]"  5 5 5 5;
createNode animCurveTL -n "FKAnkle_L_translateX";
	rename -uid "4FD6F599-45DA-1600-73CD-D793403152D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 -1.9770462737074759 9 0 14 0 16 0;
createNode animCurveTL -n "FKAnkle_L_translateY";
	rename -uid "4F841577-454D-4344-EE78-8882440B7F0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 0.12684209070240371 9 0 14 0 16 0;
createNode animCurveTL -n "FKAnkle_L_translateZ";
	rename -uid "B3BB505E-410F-11E4-936E-289D7E864848";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 -0.094660383806584036 9 0 14 0 16 0;
createNode animCurveTU -n "FKAnkle_L_scaleX";
	rename -uid "4BE43F80-47A4-588A-453C-C4B522393F1D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKAnkle_L_scaleY";
	rename -uid "5B183A76-41E0-113D-372F-E2A0336F176E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode animCurveTU -n "FKAnkle_L_scaleZ";
	rename -uid "CCF05635-424C-099E-F7D5-1599C9F3106B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 4 ".ktv[0:3]"  1 1 9 1 14 1 16 1;
createNode script -n "sceneConfigurationScriptNode";
	rename -uid "025A4386-4E1A-6089-21E1-7B920579E750";
	setAttr ".b" -type "string" "playbackOptions -min 1 -max 26 -ast 1 -aet 30 ";
	setAttr ".st" 6;
createNode animLayer -n "BaseAnimation";
	rename -uid "E152B13F-4F6A-BFE5-1566-1F99FEEAD856";
	setAttr -s 2 ".cdly";
	setAttr -s 2 ".chsl";
	setAttr ".ovrd" yes;
createNode animLayer -n "BakeResults";
	rename -uid "6E84E0BF-4C80-11D1-6491-0FA448DEED01";
	setAttr -s 15 ".dsm";
	setAttr -s 5 ".bnds";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "FKShoulder_L_rotateX_BakeResults_inputB";
	rename -uid "D3BE7A0D-443B-6D34-8E6F-7AB1DCEB8E3D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 19.253675154180986 2 4.3385688130513316
		 3 -5.5486785576887048 4 -2.1742705651211494 5 -2.2720415072078444 6 -1.3333306193897785
		 7 -0.70240419677850174 8 0.026653036208481209 9 0.051829819409505908 10 -0.47998318729326256
		 11 0.13659614777277554 12 1.4225511207791397 13 -1.3880909163567403 14 -0.52532988863168539
		 15 -8.269442171803694e-14 16 -8.269442171803694e-14 17 -0.17077439093334895 18 0.13272511986187763
		 19 0.18599164186727529 20 -0.044895305099931428 21 0.15145232471893608 22 0.14244695840831462
		 23 4.7446224333121032 24 9.3476059233968858 25 13.690682396155283 26 19.467992034448162
		 27 19.253675154180986 28 19.253675154180986 29 19.253675154180986 30 19.253675154180986;
createNode animCurveTA -n "FKShoulder_L_rotateY_BakeResults_inputB";
	rename -uid "B7C25C17-4607-5BB6-E8CB-2D81D71326E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 6.868355322655491 2 17.367192097196202
		 3 23.96817261292723 4 19.398869767763873 5 15.484571059871234 6 10.339558351436409
		 7 5.2601516653886558 8 1.4649981146469553 9 -0.0078423177945826563 10 0.86984941483791389
		 11 0.60003375338622056 12 -0.0069582510765821438 13 1.3670810707251415 14 0.30350563157642135
		 15 9.9057816141275041e-13 16 9.9057816141275041e-13 17 0.96100051597052949 18 0.99319038659346559
		 19 0.79293812059783431 20 1.421468491056054 21 1.3597668285397835 22 0.41881892131745807
		 23 -3.081691082295646 24 1.4728684481831855 25 7.4539648317397864 26 -0.10859292431893074
		 27 6.868355322655491 28 6.868355322655491 29 6.868355322655491 30 6.868355322655491;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder_L_rotate_BakeResults";
	rename -uid "B6CC283D-4A74-D141-27DC-37A22482E539";
	setAttr ".o" -type "double3" 19.467992034448162 -0.10859292431893074 8.7179406146386516 ;
createNode animCurveTA -n "FKShoulder_L_rotate_BakeResults_inputBZ";
	rename -uid "B6D5A6F2-420C-95D5-5CC4-239A645E7BBB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 362.51763657641101 2 367.62471456813068
		 3 366.94185723804907 4 366.92189545335373 5 368.06931653731158 6 367.49275902270881
		 7 5.8221398410910714 8 3.287657294828465 9 0.41172143285976104 10 345.13850060277468
		 11 339.98722468046617 12 336.95015493916344 13 339.14837691994973 14 355.29978680776418
		 15 359.99999999999829 16 359.99999999999829 17 348.62480103421251 18 346.24517067281016
		 19 345.86753071783289 20 337.53664323126765 21 340.55272974462031 22 354.97286641984118
		 23 15.221016330179356 24 341.15878098788733 25 344.50942329531364 26 8.7179406146386516
		 27 362.51763657641101 28 362.51763657641101 29 362.51763657641101 30 362.51763657641101;
createNode animCurveTA -n "FKShoulder1_L_rotateX_BakeResults_inputB";
	rename -uid "B138D81D-4E61-4A3B-9C79-DA9113E65317";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -89.217545929641773 2 231.97985241189332
		 3 192.26981047546116 4 180.89758358560087 5 182.58710786356744 6 180.69974407027067
		 7 180.42332836366336 8 359.8456553938114 9 359.6286900654635 10 358.93101500101068
		 11 356.45864472410682 12 356.6167112786697 13 176.59455456206129 14 177.04983146064771
		 15 359.54646356747071 16 359.49169984761363 17 358.71701320465218 18 354.53165633024946
		 19 354.1770563201635 20 187.92168646674588 21 354.11068644971516 22 358.43891257530265
		 23 377.05027666371456 24 210.73204523491705 25 246.4821182459948 26 259.61139530238853
		 27 -89.286990168195359 28 -89.217545929641773 29 -89.217545929641773 30 -89.217545929641773;
createNode animCurveTA -n "FKShoulder1_L_rotateY_BakeResults_inputB";
	rename -uid "3289E306-4CD5-AC88-B348-B88B204B4E7E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -195.05637840215414 2 -216.36313668139778
		 3 -239.12701083323944 4 -240.0416425685153 5 -231.19519369230102 6 -221.18254381041632
		 7 -208.8144445114618 8 18.662830920178045 9 13.193719454254863 10 12.470180176484346
		 11 13.756600874717686 12 -345.73667615873671 13 -194.66853756733758 14 -193.23830739965911
		 15 12.826962680306499 16 12.862877478589642 17 12.814814866296055 18 13.933385094050081
		 19 -345.97901057533971 20 -193.45818409724919 21 13.015371732164079 22 13.220279916045914
		 23 11.251768985684292 24 -193.71410071409991 25 -207.14862087981538 26 -192.99999982968939
		 27 -195.01917797170947 28 -195.05637840215414 29 -195.05637840215414 30 -195.05637840215414;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder1_L_rotate_BakeResults";
	rename -uid "71AD1616-4E20-5587-7F86-4F81B8EF5B7E";
	setAttr ".o" -type "double3" 259.61139530238853 -192.99999982968939 -67.368062170636662 ;
createNode animCurveTA -n "FKShoulder1_L_rotate_BakeResults_inputBZ";
	rename -uid "98BD0540-4266-559A-1693-A0A4E993A7F6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -78.765368748011753 2 -114.67685430935151
		 3 -157.84309624949975 4 -178.16111747299934 5 -185.41310631507969 6 -193.89313456447351
		 7 -199.19313728364421 8 -24.27225233212549 9 -28.549345945191625 10 -41.034034684637881
		 11 -48.477659135766807 12 -49.969502395996294 13 -237.45421060513553 14 -221.51221112897213
		 15 -29.588989983663474 16 -29.444255377567579 17 -39.043332183406115 18 -52.908691737872729
		 19 -58.289008229730229 20 -235.34724682970023 21 -48.211846202105519 22 -35.817638373528006
		 23 9.1217158223982491 24 -167.91521965345584 25 -95.960321392792508 26 -67.368062170636662
		 27 -78.704419585352781 28 -78.765368748011753 29 -78.765368748011753 30 -78.765368748011753;
createNode animCurveTA -n "FKElbow_L_rotateX_BakeResults_inputB";
	rename -uid "850F76EB-480D-9372-FA4C-75B002B81EF9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -351.66867947202894 2 -538.20628407998845
		 3 -354.73798097162779 4 -363.31608528350159 5 -363.65682022660849 6 -363.34175364914171
		 7 -362.43025204864819 8 -360.60662211096832 9 -359.07420911067004 10 -356.52087953516889
		 11 -355.03964677407208 12 -349.93016542536407 13 -343.47720060453054 14 -356.48071226197965
		 15 -358.66533509567603 16 -358.76215910632948 17 -357.10690841841023 18 -349.27693805138171
		 19 -356.72773005808989 20 -359.74187134401114 21 -343.78058334945888 22 -353.44176833933125
		 23 -401.34773448321027 24 -542.02810087005889 25 -293.93983807845422 26 -362.42472345631734
		 27 -354.40383171667509 28 -351.67036835264105 29 -351.66867947202894 30 -351.66867947202894;
createNode animCurveTA -n "FKElbow_L_rotateY_BakeResults_inputB";
	rename -uid "10B5E793-4DA1-DDB4-0A8E-E9821BD7C4D3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -6.6327048761840528 2 0.12183037772797518
		 3 13.097340251223583 4 13.986935064480692 5 16.157690183464201 6 17.555610196901206
		 7 17.84477278718591 8 16.482225769865188 9 14.070980997660916 10 11.664895599632247
		 11 14.943944602222993 12 14.684436632591503 13 7.3338916406023342 14 14.388744642057956
		 15 12.782473545480507 16 12.828899009960645 17 12.159338569404039 18 9.5912065645276705
		 19 14.586758942610942 20 10.262587421504273 21 9.1283370653553302 22 11.873673805246609
		 23 8.7415097091695593 24 3.8468868286294029 25 -5.6479645472378417 26 -1.0313650349151506
		 27 -4.560238338570838 28 -6.6309585980125068 29 -6.6327048761840528 30 -6.6327048761840528;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow_L_rotate_BakeResults";
	rename -uid "594E0655-42E3-5337-4E41-9A862DF56723";
	setAttr ".o" -type "double3" -362.42472345631734 -1.0313650349151506 387.73528685034256 ;
createNode animCurveTA -n "FKElbow_L_rotate_BakeResults_inputBZ";
	rename -uid "653DA40C-4988-7FFB-1629-C3B205B18CEC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 395.8559491856862 2 569.31461565861639
		 3 360.97826260218852 4 361.26410424963439 5 359.81523586116759 6 360.43927947599781
		 7 360.07539867267832 8 358.35124111569797 9 714.07475150579739 10 702.6188373361224
		 11 684.14640010374887 12 677.15142793619907 13 679.64069044536234 14 692.51126990287003
		 15 711.44876347992783 16 712.40749963650376 17 704.67416793741984 18 690.33895061188912
		 19 689.16800925279983 20 691.09829546928836 21 686.66951706434668 22 702.12560610516721
		 23 413.93724620231529 24 541.04963930144584 25 689.47601562219825 26 387.73528685034256
		 27 396.01555806429758 28 395.85786924536984 29 395.8559491856862 30 395.8559491856862;
createNode animCurveTA -n "FKElbow1_L_rotateX_BakeResults_inputB";
	rename -uid "BBD9D54F-4FAE-FA6E-6115-E2B4A2C01E89";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 537.23671618652918 2 351.4643954230865
		 3 358.39489942782916 4 359.06395058538118 5 355.99897629298755 6 356.23754035361577
		 7 536.35843851503682 8 537.63192800781098 9 539.00238733677008 10 538.2184348099189
		 11 552.58609706686468 12 727.01410733113971 13 732.18866161206711 14 544.99569153226946
		 15 538.27421396795171 16 539.37642492493558 17 538.66649801303765 18 544.49612654414329
		 19 732.69800209455536 20 720.23419192479855 21 726.63945136941243 22 719.10416950086369
		 23 593.46191590540184 24 541.97485851121417 25 646.87660368144111 26 521.42723770454256
		 27 542.52666393161621 28 537.25327463575684 29 537.23674174701114 30 537.23671618652918;
createNode animCurveTA -n "FKElbow1_L_rotateY_BakeResults_inputB";
	rename -uid "59826EC0-4B15-2E3A-BE3F-D7ACD6CC99A6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 189.50247313224793 2 171.77243572756348
		 3 11.849821439735132 4 379.29905446568273 5 379.79556591445936 6 379.36993846279614
		 7 -200.39361439821815 8 -197.89936816149654 9 -194.96667574991201 10 -191.82200428134411
		 11 166.55433947446764 12 15.569802010977359 13 11.190937756286196 14 161.70418675070019
		 15 -193.07489796986732 16 -192.8965318289377 17 -192.08057833877774 18 -189.97879287397546
		 19 14.243856332273026 20 13.24929458593825 21 15.453424880068996 22 14.541094715231294
		 23 174.88158831248248 24 364.37532105895855 25 -5.64950234944458 26 175.87813768191174
		 27 183.44754836452125 28 189.3831204863788 29 189.50247313224793 30 189.50247313224793;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow1_L_rotate_BakeResults";
	rename -uid "2BC92235-457E-9DB9-C798-E29B8860F732";
	setAttr ".o" -type "double3" 521.42723770454256 175.87813768191174 -506.17848704243124 ;
createNode animCurveTA -n "FKElbow1_L_rotate_BakeResults_inputBZ";
	rename -uid "1AB04B5F-42D9-94A8-AF73-709B3284D55A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -499.40782562620097 2 -707.20728840194215
		 3 -723.37688800632952 4 -716.85075433909992 5 -718.66391106279764 6 -717.86377896326724
		 7 -539.45762347944924 8 -539.87311490622335 9 -544.53209319626148 10 -553.57918766755176
		 11 -567.29559910727323 12 -390.66647591807373 13 -749.20301809793682 14 -566.40855858401653
		 15 -552.03981079854589 16 -547.39240925320928 17 -551.20993798699078 18 -561.00232655835396
		 19 -382.53752839767355 20 -384.80673672757058 21 -751.37326632013571 22 -379.51804058441462
		 23 -583.00893539222648 24 -500.10123979645016 25 -253.0554481960007 26 -506.17848704243124
		 27 -499.85666044349551 28 -499.35721179365805 29 -499.40782562620097 30 -499.40782562620097;
createNode animCurveTA -n "FKWrist_L_rotateX_BakeResults_inputB";
	rename -uid "51D68572-4FC4-FD27-D2D4-5682DB2DB0EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -724.21278434642454 2 -572.77428699125471
		 3 -544.6386017726536 4 -541.08134380577701 5 -542.13861829088569 6 -542.52950339706047
		 7 -541.94214499233669 8 -542.10798240965175 9 -540.17677716048968 10 -540.29076931079544
		 11 -539.05286327475392 12 -531.27785028348865 13 -534.08574198024132 14 -527.22842079387715
		 15 -532.56595023656871 16 -538.32306027552295 17 -539.45013777694817 18 -538.92070703517936
		 19 -532.65770302817282 20 -531.74483389515558 21 -536.39683089799075 22 -520.05177303952405
		 23 -407.97028838463882 24 -550.0612281389532 25 -480.58308523559623 26 -546.17064699093794
		 27 -546.5594808635484 28 -723.08460271222339 29 -724.2125054855095 30 -724.21278434642454;
createNode animCurveTA -n "FKWrist_L_rotateY_BakeResults_inputB";
	rename -uid "A3BAEC7F-4236-442A-E1C5-EEB17314AD69";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 2.5311572011754722 2 -7.5806168489545991
		 3 170.13069312082737 4 178.42310687372267 5 173.20500466245238 6 169.87499010241697
		 7 165.99245645475574 8 164.12932856504381 9 163.42912355187528 10 168.24789752435831
		 11 167.39377116166688 12 168.20390657030589 13 165.8555340861798 14 163.65355632167174
		 15 167.3902614661705 16 167.13608896773107 17 167.78899952073519 18 167.33460808438133
		 19 166.47202628000821 20 167.69974845250607 21 168.82207016764147 22 174.36678765407507
		 23 11.545654974151335 24 28.360304103949101 25 196.64482660534529 26 166.35160726797159
		 27 164.96184815715202 28 2.9927128368164175 29 2.5333774425665503 30 2.5311572011754722;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKWrist_L_rotate_BakeResults";
	rename -uid "EEECCED2-470E-24CE-4FBA-508B7C5CF1DD";
	setAttr ".o" -type "double3" -546.17064699093794 166.35160726797159 571.2901194740856 ;
createNode animCurveTA -n "FKWrist_L_rotate_BakeResults_inputBZ";
	rename -uid "C74AC7D9-42B0-7FD9-4D04-1CBEDB07E535";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 757.49608592277616 2 573.91111601162618
		 3 537.11222345872466 4 538.77768712186389 5 536.83288144134769 6 536.11445070245475
		 7 536.60887560268873 8 536.06682083193527 9 533.49009620812217 10 531.79989713018779
		 11 525.19530645312636 12 519.69246717472686 13 515.52613442821632 14 515.10878399138983
		 15 520.6107708658725 16 529.28964455551068 17 531.36787419920381 18 525.319777867521
		 19 517.97729285058665 20 516.95528478823951 21 521.96158385354454 22 514.2304940431917
		 23 772.50308864840144 24 526.78088415815432 25 515.33746560663565 26 571.2901194740856
		 27 576.24385395389311 28 757.82176262604924 29 757.49736812230219 30 757.49608592277616;
createNode container -n "BakeResultsContainer";
	rename -uid "C79F992E-40D2-582E-2F53-14BD22C3736E";
	setAttr ".isc" yes;
	setAttr ".ctor" -type "string" "codyr";
	setAttr ".cdat" -type "string" "2026/01/26 21:53:08";
createNode hyperLayout -n "hyperLayout1";
	rename -uid "B3CBCDE2-40FE-49E2-E637-42B914DC90FF";
	setAttr ".ihi" 0;
	setAttr -s 6 ".hyp";
createNode objectSet -n "OverlapperSet";
	rename -uid "746C1B7D-4807-E675-76CD-49857EAFE342";
	setAttr ".ihi" 0;
	setAttr -s 5 ".dsm";
createNode animLayer -n "BakeResults1";
	rename -uid "BE48EBE8-4E58-F6D1-42CB-AD9E7753271F";
	setAttr -s 15 ".dsm";
	setAttr -s 5 ".bnds";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "FKShoulder_R_rotateX_BakeResults1_inputB";
	rename -uid "30BAD451-4EA7-CA1B-6A0C-2C96D338EB41";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 2.4502457484002882 2 -5.5806479273941205
		 3 -3.6966240904395771 4 -0.12986197687152312 5 0.042738916918590636 6 0.23428565745748153
		 7 0.31659111769926451 8 0.26290552180300297 9 0.046026035691761301 10 -0.10869976547907191
		 11 0.84517949414724525 12 1.7334765001702888 13 0.062403286525728935 14 -0.18418275485087571
		 15 1.2722218725854067e-14 16 1.2722218725854067e-14 17 -0.066016966167328717 18 0.15910646251914606
		 19 0.16371050244714777 20 0.038496656992614814 21 0.19210615402982645 22 0.15881229748716735
		 23 1.4538836480483128 24 12.129999058158484 25 1.0029154899599784 26 -1.3829098664849333
		 27 2.4502457484002882 28 2.4502457484002882 29 2.4502457484002882 30 2.4502457484002882;
createNode animCurveTA -n "FKShoulder_R_rotateY_BakeResults1_inputB";
	rename -uid "C5682047-4B1F-74DD-6E2B-CB979F24937F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -4.5054574169032966 2 4.7830152806773585
		 3 10.502296608859172 4 7.8966225902416634 5 7.147984215858064 6 5.3800139421978947
		 7 3.3674492218401966 8 1.4580297928626018 9 0.12125803086189009 10 -1.8001622261049459
		 11 -2.3745999915519973 12 -2.2554674282042262 13 -2.6108189277875766 14 -0.5334388113594255
		 15 0 16 0 17 -1.0532864825804713 18 -1.3297572990071975 19 -1.2951888348117926 20 -1.437006364672861
		 21 -1.382279217405411 22 -0.31876902885256925 23 -2.8512437242895836 24 -10.123912541460815
		 25 -12.67190947225995 26 11.853255420477922 27 -4.5054574169032966 28 -4.5054574169032966
		 29 -4.5054574169032966 30 -4.5054574169032966;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder_R_rotate_BakeResults1";
	rename -uid "80D31D6E-42EC-E294-A59D-8EBB5D240E50";
	setAttr ".o" -type "double3" -1.3829098664849333 11.853255420477922 -0.52668582743239645 ;
createNode animCurveTA -n "FKShoulder_R_rotate_BakeResults1_inputBZ";
	rename -uid "CA87F5F5-4C5E-4070-A44B-38A988980784";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 7.1291147983236547 2 9.1670844788645969
		 3 1.9976097787791454 4 -1.33535900651649 5 -2.5349537994531319 6 -3.0659278973355635
		 7 -2.8468668979716325 8 -1.9235014757669606 9 -0.27748945077648185 10 16.078126631133049
		 11 23.617692074992043 12 27.542898586251518 13 24.981478881484637 14 5.3149001600012857
		 15 0 16 0 17 12.559803578237137 18 16.528551170471705 19 16.975711104804315 20 18.692271775697954
		 21 19.184450643767057 22 3.91710400731455 23 -14.224434484817532 24 18.336350724014778
		 25 13.015177341252826 26 -0.52668582743239645 27 7.1291147983236547 28 7.1291147983236547
		 29 7.1291147983236547 30 7.1291147983236547;
createNode animCurveTA -n "FKShoulder1_R_rotateX_BakeResults1_inputB";
	rename -uid "A3429751-4DCB-4E4F-4D72-45976485CC9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -55.306140431184964 2 -34.665950614929073
		 3 168.23774214527469 4 -184.9251432872108 5 165.27880238126994 6 148.86670386456248
		 7 -47.782782072922572 8 -61.505256030963295 9 -67.899395751388482 10 -64.817313717261371
		 11 -67.535659800168958 12 -68.112277473035775 13 -242.05028973596606 14 -66.973480156300411
		 15 -67.970486470175729 16 -68.135238754044593 17 -65.291841974544965 18 -64.284865325597309
		 19 -64.063756577765972 20 -63.3836637967215 21 -70.510769540336881 22 -66.89406965886954
		 23 -66.011668571371686 24 -62.157860126772633 25 -53.355969006624562 26 -71.401343734039983
		 27 -55.542097167131672 28 -55.306140431184964 29 -55.306140431184964 30 -55.306140431184964;
createNode animCurveTA -n "FKShoulder1_R_rotateY_BakeResults1_inputB";
	rename -uid "8BAFC8C9-41AF-A5C6-6F1C-DD900B6C1176";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -8.408651474524067 2 23.784532923612698
		 3 118.64415760944794 4 114.34325255209707 5 121.35444440202484 6 130.99179261749336
		 7 38.326739471814669 8 29.415606099543869 9 24.533935744980447 10 25.334053960230548
		 11 30.362958522729027 12 32.375931666593658 13 -214.22563776170068 14 25.660734472828654
		 15 24.147350415945169 16 24.219009181435897 17 25.381694568595663 18 27.540481447396925
		 19 28.645905409682545 20 28.118377636685647 21 25.913689447063753 22 25.406827222637798
		 23 20.34197506172336 24 -1.2882269700105853 25 -17.203000310182759 26 8.4115873511822876
		 27 -8.2698987621787605 28 -8.408651474524067 29 -8.408651474524067 30 -8.408651474524067;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder1_R_rotate_BakeResults1";
	rename -uid "0AC94F09-45D3-C9EB-2E6B-9F82799D54AC";
	setAttr ".o" -type "double3" -71.401343734039983 8.4115873511822876 -68.766052055628322 ;
createNode animCurveTA -n "FKShoulder1_R_rotate_BakeResults1_inputBZ";
	rename -uid "4F596CD6-4975-BCA0-775F-21A8BE278BD4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -55.898186872524839 2 -31.160001444684909
		 3 171.88869579904627 4 -185.73280654867469 5 159.79392626966282 6 140.32938988829417
		 7 -58.885343983808205 8 -74.256821177865959 9 -80.591582434884288 10 -70.207563421831665
		 11 -58.244664555005329 12 -64.024256267882109 13 121.5176062809319 14 -68.052553152610841
		 15 -80.391408716178219 16 -80.651998817207456 17 -72.211740151385143 18 -58.343671118397545
		 19 -54.790422383845517 20 -55.664637012220076 21 -63.240902956426012 22 -75.713172499746349
		 23 -95.409510416709367 24 -50.314947650936176 25 -59.771240148898812 26 -68.766052055628322
		 27 -56.063625281087411 28 -55.898186872524839 29 -55.898186872524839 30 -55.898186872524839;
createNode animCurveTA -n "FKElbow_R_rotateX_BakeResults1_inputB";
	rename -uid "3E7D483C-4AAF-B497-6A31-2AB3F56D17CE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -0.4176958471512523 2 -2.3457000935727659
		 3 -5.1171115755315659 4 -0.046750755693814747 5 1.4645227779799934 6 2.0101817500324968
		 7 1.8998757751860771 8 1.5894008900129029 9 0.44330743789356736 10 -2.0002581465177989
		 11 -2.3680713835177372 12 -10.605440231678733 13 -4.0056307763507482 14 -2.7838597163536472
		 15 0.068256207036914429 16 0.010961278991916715 17 -0.98806042067604027 18 -1.1136397035071346
		 19 -7.8747411115290422 20 -5.0307645265136012 21 -2.7340144065088618 22 -1.4832934897485117
		 23 2.4050170802266146 24 3.4306322610377862 25 1.1581332992162614 26 -11.411259525157069
		 27 -4.5138091130833127 28 -0.42182476401404767 29 -0.4176958471512523 30 -0.4176958471512523;
createNode animCurveTA -n "FKElbow_R_rotateY_BakeResults1_inputB";
	rename -uid "D87220F0-4C29-E5B8-DDF0-9B8266C03BCD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 10.202813519581268 2 12.143096129716968
		 3 13.135043464105635 4 18.294537135627561 5 18.947557945947096 6 14.302191975271064
		 7 8.4747729348659657 8 3.0460954101457456 9 0.19541802363832603 10 -8.9443715444940608
		 11 -24.601830518241254 12 -29.164735126599727 13 -20.255502079780669 14 -14.204437206360701
		 15 -0.87989252648708483 16 -0.090575111305614825 17 -6.0779069611436292 18 -19.911766038049311
		 19 -25.056770095649807 20 -20.683104836035891 21 -19.749848620579684 22 -6.2996321436420741
		 23 17.035348158295346 24 -15.228268899353603 25 -1.560113056553758 26 23.440820872879858
		 27 13.860190296032886 28 10.207942504383253 29 10.202813519581268 30 10.202813519581268;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow_R_rotate_BakeResults1";
	rename -uid "BB06E370-430B-CE2A-A713-A19EDA78E372";
	setAttr ".o" -type "double3" -11.411259525157069 23.440820872879858 19.252736587912384 ;
createNode animCurveTA -n "FKElbow_R_rotate_BakeResults1_inputBZ";
	rename -uid "D1C13652-4F2F-D101-C20B-E997455D060F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 9.3044003866785641 2 -2.7275455671857287
		 3 -6.7762062454693037 4 0.50441273451633928 5 7.7009344091073553 6 15.994838519032886
		 7 24.241879978722835 8 30.096682633888321 9 31.960524630794851 10 38.291498469132883
		 11 46.628932498126396 12 51.53183477454327 13 51.637521064270082 14 41.604136631491436
		 15 31.650821788713817 16 31.125819406557302 17 36.920531111189298 18 41.326939894813428
		 19 41.980609576056111 20 43.524434100061946 21 47.078452152279873 22 36.306402993310229
		 23 20.836918983485965 24 30.732710490162177 25 0.28198266606070732 26 19.252736587912384
		 27 10.524959741415476 28 9.2994876161379025 29 9.3044003866785641 30 9.3044003866785641;
createNode animCurveTA -n "FKElbow1_R_rotateX_BakeResults1_inputB";
	rename -uid "8740993D-49F7-03F5-186C-BF9AA7D57440";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 2.1697266848829546 2 -1.2634395818830202
		 3 -3.7667158114387131 4 -180.28241204449617 5 2.0132391948511432 6 4.1928359461987199
		 7 3.8438441401137431 8 2.2174528432253751 9 0.42956976849912987 10 0.059242467870068018
		 11 -12.295139475518104 12 -201.92682325192729 13 -198.2791140819138 14 -186.23559257616029
		 15 -2.6571020651269048 16 -0.016551208629419594 17 0.12873233786215701 18 -188.4889896687443
		 19 -197.68165051696124 20 -191.5810459840516 21 -194.81382136910227 22 -2.4761350076598201
		 23 7.9535883867504493 24 -0.46359582829264478 25 -5.8353328931976476 26 0.91344205517879307
		 27 2.6091732994824679 28 1.8653084134105078 29 2.1697247520104788 30 2.1697266848829546;
createNode animCurveTA -n "FKElbow1_R_rotateY_BakeResults1_inputB";
	rename -uid "90A55131-4AA9-5623-5286-319E968D01A1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 9.5451742293379134 2 3.8098866682931054
		 3 -8.0302268446247336 4 -180.66803833913744 5 3.5927906690153999 6 2.6704558371133129
		 7 0.390138427027447 8 -1.0456063326666094 9 -1.4329395087479602 10 -3.0712342746965202
		 11 -361.51696581767163 12 176.77273253018407 13 173.62909010265611 14 176.71991139703115
		 15 0.69485043003786506 16 -0.080039910777715453 17 -1.8221214715017966 18 -179.53092827918761
		 19 181.54933822102845 20 179.44232158513128 21 179.63856341857846 22 3.9105934705469325
		 23 3.8877732865906225 24 -7.5607305755010117 25 3.8526808522135245 26 17.48157255862181
		 27 20.254207859727451 28 9.6518728253228208 29 9.5451742293379187 30 9.5451742293379134;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow1_R_rotate_BakeResults1";
	rename -uid "FE664B6A-4440-164C-78AE-ADAEA54525B2";
	setAttr ".o" -type "double3" 0.91344205517879307 17.48157255862181 19.849427881098382 ;
createNode animCurveTA -n "FKElbow1_R_rotate_BakeResults1_inputBZ";
	rename -uid "4783FF28-4B7B-5B47-FFEE-BEB50158DA21";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 19.637773848937563 2 1.9463952738252335
		 3 -10.103726355440356 4 -180.81091328889462 5 13.028308511277164 6 29.063662989471339
		 7 45.95236852344361 8 58.434037423094829 9 65.470164847364629 10 67.61766603336433
		 11 70.717112416551146 12 -108.61405642641536 13 -107.71065180719894 14 -103.81214853515331
		 15 66.991390011114973 16 65.486774077784034 17 66.985270251055454 18 -107.90832650428483
		 19 -106.4581670809528 20 -107.67806832896402 21 -107.7560115081848 22 69.689759329142774
		 23 50.629458162516109 24 56.149785225637466 25 31.159234026636305 26 19.849427881098382
		 27 20.743360752462291 28 19.610881103211632 29 19.637773848937574 30 19.637773848937563;
createNode animCurveTA -n "FKWrist_R_rotateX_BakeResults1_inputB";
	rename -uid "5664DDDC-41AA-B14B-9257-789291A1D41A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -5.7924777679870596 2 -4.7920732597000333
		 3 -3.8520523902409067 4 -0.9296207625786066 5 2.5918264279543046 6 4.4939957979799434
		 7 4.8032255232981855 8 2.4965021685990219 9 1.2406277108865387 10 0.45971695930301237
		 11 -6.1192395010743326 12 -4.8911442057991623 13 -3.1134230623995762 14 -15.976658275203237
		 15 -3.1888107928284763 16 -0.045710346332127137 17 0.324838909056475 18 -3.6443382533065956
		 19 -15.749801162264539 20 -10.617704547958972 21 -15.388548465810763 22 -4.2767450406711225
		 23 5.2922425776936626 24 1.4068055685648082 25 -18.332513806446578 26 -8.6193583686633559
		 27 -8.023346107100874 28 -6.302551189505273 29 -5.797725931695032 30 -5.7924777679870596;
createNode animCurveTA -n "FKWrist_R_rotateY_BakeResults1_inputB";
	rename -uid "F40B48F6-4727-E316-A735-419807B31438";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 -4.400183005139831 2 1.401472577073124
		 3 3.8342919367364758 4 10.733101445043095 5 12.533451227983058 6 10.343051591635273
		 7 5.5162732033546842 8 -0.091914314974790426 9 -0.99786428384952519 10 -1.8729494576180861
		 11 -1.3218526706587308 12 0.41329032391702547 13 3.6163095089466704 14 2.149788703839616
		 15 1.7813340088413141 16 0.096044077321202112 17 -0.45439264791570422 18 -1.9428380768115161
		 19 -4.9592862247621996 20 -0.733118608474983 21 -0.92706349559219381 22 5.2423916440493885
		 23 -0.42138456491029047 24 -6.3573101051145411 25 -9.4064613344732972 26 0.64353663501871872
		 27 11.677967238641973 28 -3.2207755940176011 29 -4.3975525306232566 30 -4.400183005139831;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKWrist_R_rotate_BakeResults1";
	rename -uid "BB586193-421A-A48A-86BE-FFB281C00593";
	setAttr ".o" -type "double3" -8.6193583686633559 0.64353663501871872 22.635763936664048 ;
createNode animCurveTA -n "FKWrist_R_rotate_BakeResults1_inputBZ";
	rename -uid "762FA3DB-4B77-351A-2698-FEABC00A3F67";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 30 ".ktv[0:29]"  1 21.290586712836674 2 3.9164997422323391
		 3 -10.231342804514323 4 -6.0723697600061781 5 0.41279385562732007 6 6.9562931922137912
		 7 14.238334756606404 8 20.490100370950167 9 24.835714010451294 10 27.146202969969004
		 11 31.178050018489259 12 31.58472669855156 13 32.185033827181421 14 36.918310256256888
		 15 30.283336157409916 16 25.974192079512584 17 26.031001384977809 18 30.93097201167091
		 19 31.135371330273589 20 31.286760095572209 21 32.994559906998383 22 31.599862657902939
		 23 19.562819533270972 24 35.626031845300147 25 35.135669129015255 26 22.635763936664048
		 27 23.152688344399511 28 21.639811437208582 29 21.284367551088575 30 21.290586712836674;
createNode container -n "BakeResults1Container";
	rename -uid "638ED6F5-4FCF-90C2-02FB-DFB872573C13";
	setAttr ".isc" yes;
	setAttr ".ctor" -type "string" "codyr";
	setAttr ".cdat" -type "string" "2026/01/26 21:53:51";
createNode hyperLayout -n "hyperLayout2";
	rename -uid "31A96396-480A-0445-2CC0-60AC118AAD74";
	setAttr ".ihi" 0;
	setAttr -s 6 ".hyp";
select -ne :time1;
	setAttr ".o" 26;
	setAttr ".unw" 26;
select -ne :hardwareRenderingGlobals;
	setAttr ".otfna" -type "stringArray" 22 "NURBS Curves" "NURBS Surfaces" "Polygons" "Subdiv Surface" "Particles" "Particle Instance" "Fluids" "Strokes" "Image Planes" "UI" "Lights" "Cameras" "Locators" "Joints" "IK Handles" "Deformers" "Motion Trails" "Components" "Hair Systems" "Follicles" "Misc. UI" "Ornaments"  ;
	setAttr ".otfva" -type "Int32Array" 22 0 1 1 1 1 1
		 1 1 1 0 0 0 0 0 0 0 0 0
		 0 0 0 0 ;
	setAttr ".fprt" yes;
select -ne :renderPartition;
	setAttr -s 23 ".st";
select -ne :renderGlobalsList1;
select -ne :defaultShaderList1;
	setAttr -s 19 ".s";
select -ne :postProcessList1;
	setAttr -s 2 ".p";
select -ne :defaultRenderUtilityList1;
	setAttr -s 5 ".u";
select -ne :defaultRenderingList1;
	setAttr -s 2 ".r";
select -ne :defaultTextureList1;
	setAttr -s 3 ".tx";
select -ne :initialShadingGroup;
	setAttr ".ro" yes;
select -ne :initialParticleSE;
	setAttr ".ro" yes;
select -ne :defaultRenderGlobals;
	addAttr -ci true -h true -sn "dss" -ln "defaultSurfaceShader" -dt "string";
	setAttr ".ren" -type "string" "arnold";
	setAttr ".dss" -type "string" "lambert1";
select -ne :defaultResolution;
	setAttr ".pa" 1;
select -ne :defaultColorMgtGlobals;
	setAttr ".cfe" yes;
	setAttr ".cfp" -type "string" "<MAYA_RESOURCES>/OCIO-configs/Maya2022-default/config.ocio";
	setAttr ".vtn" -type "string" "ACES 1.0 SDR-video (sRGB)";
	setAttr ".vn" -type "string" "ACES 1.0 SDR-video";
	setAttr ".dn" -type "string" "sRGB";
	setAttr ".wsn" -type "string" "ACEScg";
	setAttr ".otn" -type "string" "ACES 1.0 SDR-video (sRGB)";
	setAttr ".potn" -type "string" "ACES 1.0 SDR-video (sRGB)";
select -ne :hardwareRenderGlobals;
	setAttr ".ctrs" 256;
	setAttr ".btrs" 512;
select -ne :ikSystem;
	setAttr -s 3 ".sol";
connectAttr "pairBlend1.otx" "Sid_RigRN.phl[1]";
connectAttr "pairBlend1.oty" "Sid_RigRN.phl[2]";
connectAttr "pairBlend1.otz" "Sid_RigRN.phl[3]";
connectAttr "pairBlend1.orx" "Sid_RigRN.phl[4]";
connectAttr "pairBlend1.ory" "Sid_RigRN.phl[5]";
connectAttr "pairBlend1.orz" "Sid_RigRN.phl[6]";
connectAttr "Sid_RigRN.phl[7]" "pairBlend1.w";
connectAttr "Collar_Ctrl_Master_blendParent1.o" "Sid_RigRN.phl[8]";
connectAttr "Sid_RigRN.phl[9]" "pairBlend1.itx2";
connectAttr "Sid_RigRN.phl[10]" "pairBlend1.ity2";
connectAttr "Sid_RigRN.phl[11]" "pairBlend1.itz2";
connectAttr "Sid_RigRN.phl[12]" "pairBlend1.irx2";
connectAttr "Sid_RigRN.phl[13]" "pairBlend1.iry2";
connectAttr "Sid_RigRN.phl[14]" "pairBlend1.irz2";
connectAttr "Main_visibility.o" "Sid_RigRN.phl[15]";
connectAttr "Main_scaleX.o" "Sid_RigRN.phl[16]";
connectAttr "Main_scaleY.o" "Sid_RigRN.phl[17]";
connectAttr "Main_scaleZ.o" "Sid_RigRN.phl[18]";
connectAttr "Main_rotateY.o" "Sid_RigRN.phl[19]";
connectAttr "Main_rotateX.o" "Sid_RigRN.phl[20]";
connectAttr "Main_rotateZ.o" "Sid_RigRN.phl[21]";
connectAttr "Main_translateX.o" "Sid_RigRN.phl[22]";
connectAttr "Main_translateY.o" "Sid_RigRN.phl[23]";
connectAttr "Main_translateZ.o" "Sid_RigRN.phl[24]";
connectAttr "FKToes_R_rotateX.o" "Sid_RigRN.phl[25]";
connectAttr "FKToes_R_rotateY.o" "Sid_RigRN.phl[26]";
connectAttr "FKToes_R_rotateZ.o" "Sid_RigRN.phl[27]";
connectAttr "FKHip_R_scaleX.o" "Sid_RigRN.phl[28]";
connectAttr "FKHip_R_scaleY.o" "Sid_RigRN.phl[29]";
connectAttr "FKHip_R_scaleZ.o" "Sid_RigRN.phl[30]";
connectAttr "FKHip_R_rotateY.o" "Sid_RigRN.phl[31]";
connectAttr "FKHip_R_rotateX.o" "Sid_RigRN.phl[32]";
connectAttr "FKHip_R_rotateZ.o" "Sid_RigRN.phl[33]";
connectAttr "FKHip_R_visibility.o" "Sid_RigRN.phl[34]";
connectAttr "FKHip_R_translateX.o" "Sid_RigRN.phl[35]";
connectAttr "FKHip_R_translateY.o" "Sid_RigRN.phl[36]";
connectAttr "FKHip_R_translateZ.o" "Sid_RigRN.phl[37]";
connectAttr "FKKnee_R_scaleX.o" "Sid_RigRN.phl[38]";
connectAttr "FKKnee_R_scaleY.o" "Sid_RigRN.phl[39]";
connectAttr "FKKnee_R_scaleZ.o" "Sid_RigRN.phl[40]";
connectAttr "FKKnee_R_rotateX.o" "Sid_RigRN.phl[41]";
connectAttr "FKKnee_R_rotateY.o" "Sid_RigRN.phl[42]";
connectAttr "FKKnee_R_rotateZ.o" "Sid_RigRN.phl[43]";
connectAttr "FKKnee_R_visibility.o" "Sid_RigRN.phl[44]";
connectAttr "FKKnee_R_translateX.o" "Sid_RigRN.phl[45]";
connectAttr "FKKnee_R_translateY.o" "Sid_RigRN.phl[46]";
connectAttr "FKKnee_R_translateZ.o" "Sid_RigRN.phl[47]";
connectAttr "FKAnkle_R_scaleX.o" "Sid_RigRN.phl[48]";
connectAttr "FKAnkle_R_scaleY.o" "Sid_RigRN.phl[49]";
connectAttr "FKAnkle_R_scaleZ.o" "Sid_RigRN.phl[50]";
connectAttr "FKAnkle_R_rotateX.o" "Sid_RigRN.phl[51]";
connectAttr "FKAnkle_R_rotateY.o" "Sid_RigRN.phl[52]";
connectAttr "FKAnkle_R_rotateZ.o" "Sid_RigRN.phl[53]";
connectAttr "FKAnkle_R_visibility.o" "Sid_RigRN.phl[54]";
connectAttr "FKAnkle_R_translateX.o" "Sid_RigRN.phl[55]";
connectAttr "FKAnkle_R_translateY.o" "Sid_RigRN.phl[56]";
connectAttr "FKAnkle_R_translateZ.o" "Sid_RigRN.phl[57]";
connectAttr "FKHip_L_scaleX.o" "Sid_RigRN.phl[58]";
connectAttr "FKHip_L_scaleY.o" "Sid_RigRN.phl[59]";
connectAttr "FKHip_L_scaleZ.o" "Sid_RigRN.phl[60]";
connectAttr "FKHip_L_rotateX.o" "Sid_RigRN.phl[61]";
connectAttr "FKHip_L_rotateY.o" "Sid_RigRN.phl[62]";
connectAttr "FKHip_L_rotateZ.o" "Sid_RigRN.phl[63]";
connectAttr "FKHip_L_visibility.o" "Sid_RigRN.phl[64]";
connectAttr "FKHip_L_translateX.o" "Sid_RigRN.phl[65]";
connectAttr "FKHip_L_translateY.o" "Sid_RigRN.phl[66]";
connectAttr "FKHip_L_translateZ.o" "Sid_RigRN.phl[67]";
connectAttr "FKKnee_L_scaleX.o" "Sid_RigRN.phl[68]";
connectAttr "FKKnee_L_scaleY.o" "Sid_RigRN.phl[69]";
connectAttr "FKKnee_L_scaleZ.o" "Sid_RigRN.phl[70]";
connectAttr "FKKnee_L_rotateX.o" "Sid_RigRN.phl[71]";
connectAttr "FKKnee_L_rotateY.o" "Sid_RigRN.phl[72]";
connectAttr "FKKnee_L_rotateZ.o" "Sid_RigRN.phl[73]";
connectAttr "FKKnee_L_translateX.o" "Sid_RigRN.phl[74]";
connectAttr "FKKnee_L_translateY.o" "Sid_RigRN.phl[75]";
connectAttr "FKKnee_L_translateZ.o" "Sid_RigRN.phl[76]";
connectAttr "FKKnee_L_visibility.o" "Sid_RigRN.phl[77]";
connectAttr "FKAnkle_L_scaleX.o" "Sid_RigRN.phl[78]";
connectAttr "FKAnkle_L_scaleY.o" "Sid_RigRN.phl[79]";
connectAttr "FKAnkle_L_scaleZ.o" "Sid_RigRN.phl[80]";
connectAttr "FKAnkle_L_rotateX.o" "Sid_RigRN.phl[81]";
connectAttr "FKAnkle_L_rotateY.o" "Sid_RigRN.phl[82]";
connectAttr "FKAnkle_L_rotateZ.o" "Sid_RigRN.phl[83]";
connectAttr "FKAnkle_L_translateX.o" "Sid_RigRN.phl[84]";
connectAttr "FKAnkle_L_translateY.o" "Sid_RigRN.phl[85]";
connectAttr "FKAnkle_L_translateZ.o" "Sid_RigRN.phl[86]";
connectAttr "FKAnkle_L_visibility.o" "Sid_RigRN.phl[87]";
connectAttr "FKHead_M_translateX.o" "Sid_RigRN.phl[88]";
connectAttr "FKHead_M_translateY.o" "Sid_RigRN.phl[89]";
connectAttr "FKHead_M_translateZ.o" "Sid_RigRN.phl[90]";
connectAttr "FKHead_M_rotateX.o" "Sid_RigRN.phl[91]";
connectAttr "FKHead_M_rotateY.o" "Sid_RigRN.phl[92]";
connectAttr "FKHead_M_rotateZ.o" "Sid_RigRN.phl[93]";
connectAttr "Bigote02_Ctrl_translateX.o" "Sid_RigRN.phl[94]";
connectAttr "Bigote02_Ctrl_translateY.o" "Sid_RigRN.phl[95]";
connectAttr "Bigote02_Ctrl_translateZ.o" "Sid_RigRN.phl[96]";
connectAttr "Bigote02_Ctrl_rotateX.o" "Sid_RigRN.phl[97]";
connectAttr "Bigote02_Ctrl_rotateY.o" "Sid_RigRN.phl[98]";
connectAttr "Bigote02_Ctrl_rotateZ.o" "Sid_RigRN.phl[99]";
connectAttr "Bigote02_Ctrl_scaleX.o" "Sid_RigRN.phl[100]";
connectAttr "Bigote02_Ctrl_scaleY.o" "Sid_RigRN.phl[101]";
connectAttr "Bigote02_Ctrl_scaleZ.o" "Sid_RigRN.phl[102]";
connectAttr "Bigote02_Ctrl_visibility.o" "Sid_RigRN.phl[103]";
connectAttr "Bigote01_Ctrl_translateX.o" "Sid_RigRN.phl[104]";
connectAttr "Bigote01_Ctrl_translateY.o" "Sid_RigRN.phl[105]";
connectAttr "Bigote01_Ctrl_translateZ.o" "Sid_RigRN.phl[106]";
connectAttr "Bigote01_Ctrl_rotateX.o" "Sid_RigRN.phl[107]";
connectAttr "Bigote01_Ctrl_rotateY.o" "Sid_RigRN.phl[108]";
connectAttr "Bigote01_Ctrl_rotateZ.o" "Sid_RigRN.phl[109]";
connectAttr "Bigote01_Ctrl_scaleX.o" "Sid_RigRN.phl[110]";
connectAttr "Bigote01_Ctrl_scaleY.o" "Sid_RigRN.phl[111]";
connectAttr "Bigote01_Ctrl_scaleZ.o" "Sid_RigRN.phl[112]";
connectAttr "Bigote01_Ctrl_visibility.o" "Sid_RigRN.phl[113]";
connectAttr "Gorro_Ctrl_translateX.o" "Sid_RigRN.phl[114]";
connectAttr "Gorro_Ctrl_translateY.o" "Sid_RigRN.phl[115]";
connectAttr "Gorro_Ctrl_translateZ.o" "Sid_RigRN.phl[116]";
connectAttr "Gorro_Ctrl_rotateX.o" "Sid_RigRN.phl[117]";
connectAttr "Gorro_Ctrl_rotateY.o" "Sid_RigRN.phl[118]";
connectAttr "Gorro_Ctrl_rotateZ.o" "Sid_RigRN.phl[119]";
connectAttr "Sid_RigRN.phl[120]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[121]";
connectAttr "Sid_RigRN.phl[122]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[123]";
connectAttr "Sid_RigRN.phl[124]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[125]";
connectAttr "Sid_RigRN.phl[126]" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[127]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[128]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[129]";
connectAttr "Sid_RigRN.phl[130]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[131]";
connectAttr "Sid_RigRN.phl[132]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[133]";
connectAttr "Sid_RigRN.phl[134]" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[135]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[136]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[137]";
connectAttr "Sid_RigRN.phl[138]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[139]";
connectAttr "Sid_RigRN.phl[140]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[141]";
connectAttr "Sid_RigRN.phl[142]" "Sid_Rig:FKElbow_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[143]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[144]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[145]";
connectAttr "Sid_RigRN.phl[146]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[147]";
connectAttr "Sid_RigRN.phl[148]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[149]";
connectAttr "Sid_RigRN.phl[150]" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[151]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[152]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[153]";
connectAttr "Sid_RigRN.phl[154]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[155]";
connectAttr "Sid_RigRN.phl[156]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[157]";
connectAttr "Sid_RigRN.phl[158]" "Sid_Rig:FKWrist_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[159]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[160]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.ox" "Sid_RigRN.phl[161]";
connectAttr "Sid_RigRN.phl[162]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.oy" "Sid_RigRN.phl[163]";
connectAttr "Sid_RigRN.phl[164]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.oz" "Sid_RigRN.phl[165]";
connectAttr "Sid_RigRN.phl[166]" "Sid_Rig:FKShoulder_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[167]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.oz" "Sid_RigRN.phl[168]";
connectAttr "Sid_RigRN.phl[169]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.oy" "Sid_RigRN.phl[170]";
connectAttr "Sid_RigRN.phl[171]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.ox" "Sid_RigRN.phl[172]";
connectAttr "Sid_RigRN.phl[173]" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[174]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.ox" "Sid_RigRN.phl[175]";
connectAttr "Sid_RigRN.phl[176]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.oy" "Sid_RigRN.phl[177]";
connectAttr "Sid_RigRN.phl[178]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.oz" "Sid_RigRN.phl[179]";
connectAttr "Sid_RigRN.phl[180]" "Sid_Rig:FKElbow_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[181]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.ox" "Sid_RigRN.phl[182]";
connectAttr "Sid_RigRN.phl[183]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.oy" "Sid_RigRN.phl[184]";
connectAttr "Sid_RigRN.phl[185]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.oz" "Sid_RigRN.phl[186]";
connectAttr "Sid_RigRN.phl[187]" "Sid_Rig:FKElbow1_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[188]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.ox" "Sid_RigRN.phl[189]";
connectAttr "Sid_RigRN.phl[190]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.oy" "Sid_RigRN.phl[191]";
connectAttr "Sid_RigRN.phl[192]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.oz" "Sid_RigRN.phl[193]";
connectAttr "Sid_RigRN.phl[194]" "Sid_Rig:FKWrist_L_rotate_BakeResults.ro";
connectAttr "FKMiddleFinger1_R_rotateX.o" "Sid_RigRN.phl[195]";
connectAttr "FKMiddleFinger1_R_rotateY.o" "Sid_RigRN.phl[196]";
connectAttr "FKMiddleFinger1_R_rotateZ.o" "Sid_RigRN.phl[197]";
connectAttr "FKMiddleFinger2_R_rotateX.o" "Sid_RigRN.phl[198]";
connectAttr "FKMiddleFinger2_R_rotateY.o" "Sid_RigRN.phl[199]";
connectAttr "FKMiddleFinger2_R_rotateZ.o" "Sid_RigRN.phl[200]";
connectAttr "FKMiddleFinger3_R_rotateX.o" "Sid_RigRN.phl[201]";
connectAttr "FKMiddleFinger3_R_rotateY.o" "Sid_RigRN.phl[202]";
connectAttr "FKMiddleFinger3_R_rotateZ.o" "Sid_RigRN.phl[203]";
connectAttr "FKThumbFinger1_R_rotateX.o" "Sid_RigRN.phl[204]";
connectAttr "FKThumbFinger1_R_rotateY.o" "Sid_RigRN.phl[205]";
connectAttr "FKThumbFinger1_R_rotateZ.o" "Sid_RigRN.phl[206]";
connectAttr "FKThumbFinger2_R_rotateX.o" "Sid_RigRN.phl[207]";
connectAttr "FKThumbFinger2_R_rotateY.o" "Sid_RigRN.phl[208]";
connectAttr "FKThumbFinger2_R_rotateZ.o" "Sid_RigRN.phl[209]";
connectAttr "FKThumbFinger3_R_rotateX.o" "Sid_RigRN.phl[210]";
connectAttr "FKThumbFinger3_R_rotateY.o" "Sid_RigRN.phl[211]";
connectAttr "FKThumbFinger3_R_rotateZ.o" "Sid_RigRN.phl[212]";
connectAttr "FKIndexFinger1_R_rotateX.o" "Sid_RigRN.phl[213]";
connectAttr "FKIndexFinger1_R_rotateY.o" "Sid_RigRN.phl[214]";
connectAttr "FKIndexFinger1_R_rotateZ.o" "Sid_RigRN.phl[215]";
connectAttr "FKIndexFinger2_R_rotateX.o" "Sid_RigRN.phl[216]";
connectAttr "FKIndexFinger2_R_rotateY.o" "Sid_RigRN.phl[217]";
connectAttr "FKIndexFinger2_R_rotateZ.o" "Sid_RigRN.phl[218]";
connectAttr "FKIndexFinger3_R_rotateX.o" "Sid_RigRN.phl[219]";
connectAttr "FKIndexFinger3_R_rotateY.o" "Sid_RigRN.phl[220]";
connectAttr "FKIndexFinger3_R_rotateZ.o" "Sid_RigRN.phl[221]";
connectAttr "FKPinkyFinger1_R_rotateX.o" "Sid_RigRN.phl[222]";
connectAttr "FKPinkyFinger1_R_rotateY.o" "Sid_RigRN.phl[223]";
connectAttr "FKPinkyFinger1_R_rotateZ.o" "Sid_RigRN.phl[224]";
connectAttr "FKPinkyFinger2_R_rotateX.o" "Sid_RigRN.phl[225]";
connectAttr "FKPinkyFinger2_R_rotateY.o" "Sid_RigRN.phl[226]";
connectAttr "FKPinkyFinger2_R_rotateZ.o" "Sid_RigRN.phl[227]";
connectAttr "FKPinkyFinger3_R_rotateX.o" "Sid_RigRN.phl[228]";
connectAttr "FKPinkyFinger3_R_rotateY.o" "Sid_RigRN.phl[229]";
connectAttr "FKPinkyFinger3_R_rotateZ.o" "Sid_RigRN.phl[230]";
connectAttr "FKSpine1_M_uiTreatment.o" "Sid_RigRN.phl[231]";
connectAttr "FKSpine1_M_translateX.o" "Sid_RigRN.phl[232]";
connectAttr "FKSpine1_M_translateY.o" "Sid_RigRN.phl[233]";
connectAttr "FKSpine1_M_translateZ.o" "Sid_RigRN.phl[234]";
connectAttr "FKSpine1_M_rotateX.o" "Sid_RigRN.phl[235]";
connectAttr "FKSpine1_M_rotateY.o" "Sid_RigRN.phl[236]";
connectAttr "FKSpine1_M_rotateZ.o" "Sid_RigRN.phl[237]";
connectAttr "FKChest_M_translateX.o" "Sid_RigRN.phl[238]";
connectAttr "FKChest_M_translateY.o" "Sid_RigRN.phl[239]";
connectAttr "FKChest_M_translateZ.o" "Sid_RigRN.phl[240]";
connectAttr "FKChest_M_rotateX.o" "Sid_RigRN.phl[241]";
connectAttr "FKChest_M_rotateY.o" "Sid_RigRN.phl[242]";
connectAttr "FKChest_M_rotateZ.o" "Sid_RigRN.phl[243]";
connectAttr "FKRoot_M_translateX.o" "Sid_RigRN.phl[244]";
connectAttr "FKRoot_M_translateY.o" "Sid_RigRN.phl[245]";
connectAttr "FKRoot_M_translateZ.o" "Sid_RigRN.phl[246]";
connectAttr "FKRoot_M_rotateX.o" "Sid_RigRN.phl[247]";
connectAttr "FKRoot_M_rotateY.o" "Sid_RigRN.phl[248]";
connectAttr "FKRoot_M_rotateZ.o" "Sid_RigRN.phl[249]";
connectAttr "FKToes_L_rotateX.o" "Sid_RigRN.phl[250]";
connectAttr "FKToes_L_rotateY.o" "Sid_RigRN.phl[251]";
connectAttr "FKToes_L_rotateZ.o" "Sid_RigRN.phl[252]";
connectAttr "FKMiddleFinger1_L_rotateX.o" "Sid_RigRN.phl[253]";
connectAttr "FKMiddleFinger1_L_rotateY.o" "Sid_RigRN.phl[254]";
connectAttr "FKMiddleFinger1_L_rotateZ.o" "Sid_RigRN.phl[255]";
connectAttr "FKMiddleFinger2_L_rotateX.o" "Sid_RigRN.phl[256]";
connectAttr "FKMiddleFinger2_L_rotateY.o" "Sid_RigRN.phl[257]";
connectAttr "FKMiddleFinger2_L_rotateZ.o" "Sid_RigRN.phl[258]";
connectAttr "FKMiddleFinger3_L_rotateX.o" "Sid_RigRN.phl[259]";
connectAttr "FKMiddleFinger3_L_rotateY.o" "Sid_RigRN.phl[260]";
connectAttr "FKMiddleFinger3_L_rotateZ.o" "Sid_RigRN.phl[261]";
connectAttr "FKThumbFinger1_L_rotateX.o" "Sid_RigRN.phl[262]";
connectAttr "FKThumbFinger1_L_rotateY.o" "Sid_RigRN.phl[263]";
connectAttr "FKThumbFinger1_L_rotateZ.o" "Sid_RigRN.phl[264]";
connectAttr "FKThumbFinger2_L_rotateX.o" "Sid_RigRN.phl[265]";
connectAttr "FKThumbFinger2_L_rotateY.o" "Sid_RigRN.phl[266]";
connectAttr "FKThumbFinger2_L_rotateZ.o" "Sid_RigRN.phl[267]";
connectAttr "FKThumbFinger3_L_rotateX.o" "Sid_RigRN.phl[268]";
connectAttr "FKThumbFinger3_L_rotateY.o" "Sid_RigRN.phl[269]";
connectAttr "FKThumbFinger3_L_rotateZ.o" "Sid_RigRN.phl[270]";
connectAttr "FKIndexFinger1_L_rotateX.o" "Sid_RigRN.phl[271]";
connectAttr "FKIndexFinger1_L_rotateY.o" "Sid_RigRN.phl[272]";
connectAttr "FKIndexFinger1_L_rotateZ.o" "Sid_RigRN.phl[273]";
connectAttr "FKIndexFinger2_L_rotateX.o" "Sid_RigRN.phl[274]";
connectAttr "FKIndexFinger2_L_rotateY.o" "Sid_RigRN.phl[275]";
connectAttr "FKIndexFinger2_L_rotateZ.o" "Sid_RigRN.phl[276]";
connectAttr "FKIndexFinger3_L_rotateX.o" "Sid_RigRN.phl[277]";
connectAttr "FKIndexFinger3_L_rotateY.o" "Sid_RigRN.phl[278]";
connectAttr "FKIndexFinger3_L_rotateZ.o" "Sid_RigRN.phl[279]";
connectAttr "FKPinkyFinger1_L_rotateX.o" "Sid_RigRN.phl[280]";
connectAttr "FKPinkyFinger1_L_rotateY.o" "Sid_RigRN.phl[281]";
connectAttr "FKPinkyFinger1_L_rotateZ.o" "Sid_RigRN.phl[282]";
connectAttr "FKPinkyFinger2_L_rotateX.o" "Sid_RigRN.phl[283]";
connectAttr "FKPinkyFinger2_L_rotateY.o" "Sid_RigRN.phl[284]";
connectAttr "FKPinkyFinger2_L_rotateZ.o" "Sid_RigRN.phl[285]";
connectAttr "FKPinkyFinger3_L_rotateX.o" "Sid_RigRN.phl[286]";
connectAttr "FKPinkyFinger3_L_rotateY.o" "Sid_RigRN.phl[287]";
connectAttr "FKPinkyFinger3_L_rotateZ.o" "Sid_RigRN.phl[288]";
connectAttr "HipSwinger_M_rotateX.o" "Sid_RigRN.phl[289]";
connectAttr "HipSwinger_M_rotateY.o" "Sid_RigRN.phl[290]";
connectAttr "HipSwinger_M_rotateZ.o" "Sid_RigRN.phl[291]";
connectAttr "HipSwinger_M_stabilize.o" "Sid_RigRN.phl[292]";
connectAttr "IKLeg_R_translateY.o" "Sid_RigRN.phl[293]";
connectAttr "IKLeg_R_translateZ.o" "Sid_RigRN.phl[294]";
connectAttr "IKLeg_R_translateX.o" "Sid_RigRN.phl[295]";
connectAttr "IKLeg_R_rotateX.o" "Sid_RigRN.phl[296]";
connectAttr "IKLeg_R_rotateY.o" "Sid_RigRN.phl[297]";
connectAttr "IKLeg_R_rotateZ.o" "Sid_RigRN.phl[298]";
connectAttr "IKLeg_R_toe.o" "Sid_RigRN.phl[299]";
connectAttr "IKLeg_R_rollAngle.o" "Sid_RigRN.phl[300]";
connectAttr "IKLeg_R_roll.o" "Sid_RigRN.phl[301]";
connectAttr "IKLeg_R_stretchy.o" "Sid_RigRN.phl[302]";
connectAttr "IKLeg_R_antiPop.o" "Sid_RigRN.phl[303]";
connectAttr "IKLeg_R_Lenght1.o" "Sid_RigRN.phl[304]";
connectAttr "IKLeg_R_Lenght2.o" "Sid_RigRN.phl[305]";
connectAttr "IKLeg_R_volume.o" "Sid_RigRN.phl[306]";
connectAttr "RollHeel_R_translateX.o" "Sid_RigRN.phl[307]";
connectAttr "RollHeel_R_translateY.o" "Sid_RigRN.phl[308]";
connectAttr "RollHeel_R_translateZ.o" "Sid_RigRN.phl[309]";
connectAttr "RollHeel_R_visibility.o" "Sid_RigRN.phl[310]";
connectAttr "RollHeel_R_rotateX.o" "Sid_RigRN.phl[311]";
connectAttr "RollHeel_R_rotateY.o" "Sid_RigRN.phl[312]";
connectAttr "RollHeel_R_rotateZ.o" "Sid_RigRN.phl[313]";
connectAttr "RollHeel_R_scaleX.o" "Sid_RigRN.phl[314]";
connectAttr "RollHeel_R_scaleY.o" "Sid_RigRN.phl[315]";
connectAttr "RollHeel_R_scaleZ.o" "Sid_RigRN.phl[316]";
connectAttr "RollToesEnd_R_translateX.o" "Sid_RigRN.phl[317]";
connectAttr "RollToesEnd_R_translateY.o" "Sid_RigRN.phl[318]";
connectAttr "RollToesEnd_R_translateZ.o" "Sid_RigRN.phl[319]";
connectAttr "RollToesEnd_R_visibility.o" "Sid_RigRN.phl[320]";
connectAttr "RollToesEnd_R_rotateX.o" "Sid_RigRN.phl[321]";
connectAttr "RollToesEnd_R_rotateY.o" "Sid_RigRN.phl[322]";
connectAttr "RollToesEnd_R_rotateZ.o" "Sid_RigRN.phl[323]";
connectAttr "RollToesEnd_R_scaleX.o" "Sid_RigRN.phl[324]";
connectAttr "RollToesEnd_R_scaleY.o" "Sid_RigRN.phl[325]";
connectAttr "RollToesEnd_R_scaleZ.o" "Sid_RigRN.phl[326]";
connectAttr "RollToes_R_rotateZ.o" "Sid_RigRN.phl[327]";
connectAttr "RollToes_R_rotateX.o" "Sid_RigRN.phl[328]";
connectAttr "RollToes_R_rotateY.o" "Sid_RigRN.phl[329]";
connectAttr "RollToes_R_translateX.o" "Sid_RigRN.phl[330]";
connectAttr "RollToes_R_translateY.o" "Sid_RigRN.phl[331]";
connectAttr "RollToes_R_translateZ.o" "Sid_RigRN.phl[332]";
connectAttr "RollToes_R_visibility.o" "Sid_RigRN.phl[333]";
connectAttr "RollToes_R_scaleX.o" "Sid_RigRN.phl[334]";
connectAttr "RollToes_R_scaleY.o" "Sid_RigRN.phl[335]";
connectAttr "RollToes_R_scaleZ.o" "Sid_RigRN.phl[336]";
connectAttr "PoleLeg_R_translateX.o" "Sid_RigRN.phl[337]";
connectAttr "PoleLeg_R_translateY.o" "Sid_RigRN.phl[338]";
connectAttr "PoleLeg_R_translateZ.o" "Sid_RigRN.phl[339]";
connectAttr "PoleLeg_R_follow.o" "Sid_RigRN.phl[340]";
connectAttr "PoleLeg_R_lock.o" "Sid_RigRN.phl[341]";
connectAttr "IKLeg_L_translateY.o" "Sid_RigRN.phl[342]";
connectAttr "IKLeg_L_translateZ.o" "Sid_RigRN.phl[343]";
connectAttr "IKLeg_L_translateX.o" "Sid_RigRN.phl[344]";
connectAttr "IKLeg_L_rotateX.o" "Sid_RigRN.phl[345]";
connectAttr "IKLeg_L_rotateY.o" "Sid_RigRN.phl[346]";
connectAttr "IKLeg_L_rotateZ.o" "Sid_RigRN.phl[347]";
connectAttr "IKLeg_L_toe.o" "Sid_RigRN.phl[348]";
connectAttr "IKLeg_L_rollAngle.o" "Sid_RigRN.phl[349]";
connectAttr "IKLeg_L_roll.o" "Sid_RigRN.phl[350]";
connectAttr "IKLeg_L_stretchy.o" "Sid_RigRN.phl[351]";
connectAttr "IKLeg_L_antiPop.o" "Sid_RigRN.phl[352]";
connectAttr "IKLeg_L_Lenght1.o" "Sid_RigRN.phl[353]";
connectAttr "IKLeg_L_Lenght2.o" "Sid_RigRN.phl[354]";
connectAttr "IKLeg_L_volume.o" "Sid_RigRN.phl[355]";
connectAttr "RollHeel_L_translateX.o" "Sid_RigRN.phl[356]";
connectAttr "RollHeel_L_translateY.o" "Sid_RigRN.phl[357]";
connectAttr "RollHeel_L_translateZ.o" "Sid_RigRN.phl[358]";
connectAttr "RollHeel_L_visibility.o" "Sid_RigRN.phl[359]";
connectAttr "RollHeel_L_rotateX.o" "Sid_RigRN.phl[360]";
connectAttr "RollHeel_L_rotateY.o" "Sid_RigRN.phl[361]";
connectAttr "RollHeel_L_rotateZ.o" "Sid_RigRN.phl[362]";
connectAttr "RollHeel_L_scaleX.o" "Sid_RigRN.phl[363]";
connectAttr "RollHeel_L_scaleY.o" "Sid_RigRN.phl[364]";
connectAttr "RollHeel_L_scaleZ.o" "Sid_RigRN.phl[365]";
connectAttr "RollToesEnd_L_translateX.o" "Sid_RigRN.phl[366]";
connectAttr "RollToesEnd_L_translateY.o" "Sid_RigRN.phl[367]";
connectAttr "RollToesEnd_L_translateZ.o" "Sid_RigRN.phl[368]";
connectAttr "RollToesEnd_L_visibility.o" "Sid_RigRN.phl[369]";
connectAttr "RollToesEnd_L_rotateX.o" "Sid_RigRN.phl[370]";
connectAttr "RollToesEnd_L_rotateY.o" "Sid_RigRN.phl[371]";
connectAttr "RollToesEnd_L_rotateZ.o" "Sid_RigRN.phl[372]";
connectAttr "RollToesEnd_L_scaleX.o" "Sid_RigRN.phl[373]";
connectAttr "RollToesEnd_L_scaleY.o" "Sid_RigRN.phl[374]";
connectAttr "RollToesEnd_L_scaleZ.o" "Sid_RigRN.phl[375]";
connectAttr "RollToes_L_rotateZ.o" "Sid_RigRN.phl[376]";
connectAttr "RollToes_L_rotateX.o" "Sid_RigRN.phl[377]";
connectAttr "RollToes_L_rotateY.o" "Sid_RigRN.phl[378]";
connectAttr "RollToes_L_translateX.o" "Sid_RigRN.phl[379]";
connectAttr "RollToes_L_translateY.o" "Sid_RigRN.phl[380]";
connectAttr "RollToes_L_translateZ.o" "Sid_RigRN.phl[381]";
connectAttr "RollToes_L_visibility.o" "Sid_RigRN.phl[382]";
connectAttr "RollToes_L_scaleX.o" "Sid_RigRN.phl[383]";
connectAttr "RollToes_L_scaleY.o" "Sid_RigRN.phl[384]";
connectAttr "RollToes_L_scaleZ.o" "Sid_RigRN.phl[385]";
connectAttr "PoleLeg_L_translateX.o" "Sid_RigRN.phl[386]";
connectAttr "PoleLeg_L_translateY.o" "Sid_RigRN.phl[387]";
connectAttr "PoleLeg_L_translateZ.o" "Sid_RigRN.phl[388]";
connectAttr "PoleLeg_L_follow.o" "Sid_RigRN.phl[389]";
connectAttr "PoleLeg_L_lock.o" "Sid_RigRN.phl[390]";
connectAttr "FKIKLeg_R_FKIKBlend.o" "Sid_RigRN.phl[391]";
connectAttr "FKIKLeg_R_IKVis.o" "Sid_RigRN.phl[392]";
connectAttr "FKIKLeg_R_FKVis.o" "Sid_RigRN.phl[393]";
connectAttr "FKIKArm_R_FKIKBlend.o" "Sid_RigRN.phl[394]";
connectAttr "FKIKArm_R_IKVis.o" "Sid_RigRN.phl[395]";
connectAttr "FKIKArm_R_FKVis.o" "Sid_RigRN.phl[396]";
connectAttr "FKIKSpine_M_FKIKBlend.o" "Sid_RigRN.phl[397]";
connectAttr "FKIKSpine_M_IKVis.o" "Sid_RigRN.phl[398]";
connectAttr "FKIKSpine_M_FKVis.o" "Sid_RigRN.phl[399]";
connectAttr "FKIKLeg_L_FKIKBlend.o" "Sid_RigRN.phl[400]";
connectAttr "FKIKLeg_L_IKVis.o" "Sid_RigRN.phl[401]";
connectAttr "FKIKLeg_L_FKVis.o" "Sid_RigRN.phl[402]";
connectAttr "FKIKArm_L_FKIKBlend.o" "Sid_RigRN.phl[403]";
connectAttr "FKIKArm_L_IKVis.o" "Sid_RigRN.phl[404]";
connectAttr "FKIKArm_L_FKVis.o" "Sid_RigRN.phl[405]";
connectAttr "RootX_M_rotateZ.o" "Sid_RigRN.phl[406]";
connectAttr "RootX_M_rotateX.o" "Sid_RigRN.phl[407]";
connectAttr "RootX_M_rotateY.o" "Sid_RigRN.phl[408]";
connectAttr "RootX_M_legLock.o" "Sid_RigRN.phl[409]";
connectAttr "RootX_M_CenterBtwFeet.o" "Sid_RigRN.phl[410]";
connectAttr "RootX_M_translateX.o" "Sid_RigRN.phl[411]";
connectAttr "RootX_M_translateY.o" "Sid_RigRN.phl[412]";
connectAttr "RootX_M_translateZ.o" "Sid_RigRN.phl[413]";
connectAttr "Fingers_R_indexCurl.o" "Sid_RigRN.phl[414]";
connectAttr "Fingers_R_middleCurl.o" "Sid_RigRN.phl[415]";
connectAttr "Fingers_R_pinkyCurl.o" "Sid_RigRN.phl[416]";
connectAttr "Fingers_R_thumbCurl.o" "Sid_RigRN.phl[417]";
connectAttr "Fingers_R_spread.o" "Sid_RigRN.phl[418]";
connectAttr "Fingers_L_indexCurl.o" "Sid_RigRN.phl[419]";
connectAttr "Fingers_L_middleCurl.o" "Sid_RigRN.phl[420]";
connectAttr "Fingers_L_pinkyCurl.o" "Sid_RigRN.phl[421]";
connectAttr "Fingers_L_thumbCurl.o" "Sid_RigRN.phl[422]";
connectAttr "Fingers_L_spread.o" "Sid_RigRN.phl[423]";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "pairBlend1_inTranslateX1.o" "pairBlend1.itx1";
connectAttr "pairBlend1_inTranslateY1.o" "pairBlend1.ity1";
connectAttr "pairBlend1_inTranslateZ1.o" "pairBlend1.itz1";
connectAttr "pairBlend1_inRotateX1.o" "pairBlend1.irx1";
connectAttr "pairBlend1_inRotateY1.o" "pairBlend1.iry1";
connectAttr "pairBlend1_inRotateZ1.o" "pairBlend1.irz1";
connectAttr "BakeResults.sl" "BaseAnimation.chsl[0]";
connectAttr "BakeResults1.sl" "BaseAnimation.chsl[1]";
connectAttr "BakeResults.play" "BaseAnimation.cdly[0]";
connectAttr "BakeResults1.play" "BaseAnimation.cdly[1]";
connectAttr "BaseAnimation.csol" "BakeResults.sslo";
connectAttr "BaseAnimation.fgwt" "BakeResults.pwth";
connectAttr "BaseAnimation.omte" "BakeResults.pmte";
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.msg" "BakeResults.bnds[3]";
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.msg" "BakeResults.bnds[7]"
		;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.msg" "BakeResults.bnds[11]";
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.msg" "BakeResults.bnds[15]";
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.msg" "BakeResults.bnds[19]";
connectAttr "FKShoulder_L_rotateX.o" "Sid_Rig:FKShoulder_L_rotate_BakeResults.iax"
		;
connectAttr "FKShoulder_L_rotateY.o" "Sid_Rig:FKShoulder_L_rotate_BakeResults.iay"
		;
connectAttr "FKShoulder_L_rotateZ.o" "Sid_Rig:FKShoulder_L_rotate_BakeResults.iaz"
		;
connectAttr "FKShoulder_L_rotateX_BakeResults_inputB.o" "Sid_Rig:FKShoulder_L_rotate_BakeResults.ibx"
		;
connectAttr "FKShoulder_L_rotateY_BakeResults_inputB.o" "Sid_Rig:FKShoulder_L_rotate_BakeResults.iby"
		;
connectAttr "FKShoulder_L_rotate_BakeResults_inputBZ.o" "Sid_Rig:FKShoulder_L_rotate_BakeResults.ibz"
		;
connectAttr "BakeResults.oram" "Sid_Rig:FKShoulder_L_rotate_BakeResults.acm";
connectAttr "BakeResults.bgwt" "Sid_Rig:FKShoulder_L_rotate_BakeResults.wa";
connectAttr "BakeResults.fgwt" "Sid_Rig:FKShoulder_L_rotate_BakeResults.wb";
connectAttr "FKShoulder1_L_rotateX.o" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.iax"
		;
connectAttr "FKShoulder1_L_rotateY.o" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.iay"
		;
connectAttr "FKShoulder1_L_rotateZ.o" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.iaz"
		;
connectAttr "FKShoulder1_L_rotateX_BakeResults_inputB.o" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.ibx"
		;
connectAttr "FKShoulder1_L_rotateY_BakeResults_inputB.o" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.iby"
		;
connectAttr "FKShoulder1_L_rotate_BakeResults_inputBZ.o" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.ibz"
		;
connectAttr "BakeResults.oram" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.acm";
connectAttr "BakeResults.bgwt" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.wa";
connectAttr "BakeResults.fgwt" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.wb";
connectAttr "FKElbow_L_rotateX.o" "Sid_Rig:FKElbow_L_rotate_BakeResults.iax";
connectAttr "FKElbow_L_rotateY.o" "Sid_Rig:FKElbow_L_rotate_BakeResults.iay";
connectAttr "FKElbow_L_rotateZ.o" "Sid_Rig:FKElbow_L_rotate_BakeResults.iaz";
connectAttr "FKElbow_L_rotateX_BakeResults_inputB.o" "Sid_Rig:FKElbow_L_rotate_BakeResults.ibx"
		;
connectAttr "FKElbow_L_rotateY_BakeResults_inputB.o" "Sid_Rig:FKElbow_L_rotate_BakeResults.iby"
		;
connectAttr "FKElbow_L_rotate_BakeResults_inputBZ.o" "Sid_Rig:FKElbow_L_rotate_BakeResults.ibz"
		;
connectAttr "BakeResults.oram" "Sid_Rig:FKElbow_L_rotate_BakeResults.acm";
connectAttr "BakeResults.bgwt" "Sid_Rig:FKElbow_L_rotate_BakeResults.wa";
connectAttr "BakeResults.fgwt" "Sid_Rig:FKElbow_L_rotate_BakeResults.wb";
connectAttr "FKElbow1_L_rotateX.o" "Sid_Rig:FKElbow1_L_rotate_BakeResults.iax";
connectAttr "FKElbow1_L_rotateY.o" "Sid_Rig:FKElbow1_L_rotate_BakeResults.iay";
connectAttr "FKElbow1_L_rotateZ.o" "Sid_Rig:FKElbow1_L_rotate_BakeResults.iaz";
connectAttr "FKElbow1_L_rotateX_BakeResults_inputB.o" "Sid_Rig:FKElbow1_L_rotate_BakeResults.ibx"
		;
connectAttr "FKElbow1_L_rotateY_BakeResults_inputB.o" "Sid_Rig:FKElbow1_L_rotate_BakeResults.iby"
		;
connectAttr "FKElbow1_L_rotate_BakeResults_inputBZ.o" "Sid_Rig:FKElbow1_L_rotate_BakeResults.ibz"
		;
connectAttr "BakeResults.oram" "Sid_Rig:FKElbow1_L_rotate_BakeResults.acm";
connectAttr "BakeResults.bgwt" "Sid_Rig:FKElbow1_L_rotate_BakeResults.wa";
connectAttr "BakeResults.fgwt" "Sid_Rig:FKElbow1_L_rotate_BakeResults.wb";
connectAttr "FKWrist_L_rotateX.o" "Sid_Rig:FKWrist_L_rotate_BakeResults.iax";
connectAttr "FKWrist_L_rotateY.o" "Sid_Rig:FKWrist_L_rotate_BakeResults.iay";
connectAttr "FKWrist_L_rotateZ.o" "Sid_Rig:FKWrist_L_rotate_BakeResults.iaz";
connectAttr "FKWrist_L_rotateX_BakeResults_inputB.o" "Sid_Rig:FKWrist_L_rotate_BakeResults.ibx"
		;
connectAttr "FKWrist_L_rotateY_BakeResults_inputB.o" "Sid_Rig:FKWrist_L_rotate_BakeResults.iby"
		;
connectAttr "FKWrist_L_rotate_BakeResults_inputBZ.o" "Sid_Rig:FKWrist_L_rotate_BakeResults.ibz"
		;
connectAttr "BakeResults.oram" "Sid_Rig:FKWrist_L_rotate_BakeResults.acm";
connectAttr "BakeResults.bgwt" "Sid_Rig:FKWrist_L_rotate_BakeResults.wa";
connectAttr "BakeResults.fgwt" "Sid_Rig:FKWrist_L_rotate_BakeResults.wb";
connectAttr "hyperLayout1.msg" "BakeResultsContainer.hl";
connectAttr "BakeResults.msg" "hyperLayout1.hyp[0].dn";
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.msg" "hyperLayout1.hyp[1].dn"
		;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.msg" "hyperLayout1.hyp[2].dn"
		;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.msg" "hyperLayout1.hyp[3].dn";
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.msg" "hyperLayout1.hyp[4].dn"
		;
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.msg" "hyperLayout1.hyp[5].dn";
connectAttr "BakeResultsContainer.msg" "OverlapperSet.dnsm" -na;
connectAttr "BaseAnimation.csol" "BakeResults1.sslo";
connectAttr "BaseAnimation.fgwt" "BakeResults1.pwth";
connectAttr "BaseAnimation.omte" "BakeResults1.pmte";
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.msg" "BakeResults1.bnds[3]"
		;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.msg" "BakeResults1.bnds[7]"
		;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.msg" "BakeResults1.bnds[11]";
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.msg" "BakeResults1.bnds[15]"
		;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.msg" "BakeResults1.bnds[19]";
connectAttr "FKShoulder_R_rotateX.o" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.iax"
		;
connectAttr "FKShoulder_R_rotateY.o" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.iay"
		;
connectAttr "FKShoulder_R_rotateZ.o" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.iaz"
		;
connectAttr "FKShoulder_R_rotateX_BakeResults1_inputB.o" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.ibx"
		;
connectAttr "FKShoulder_R_rotateY_BakeResults1_inputB.o" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.iby"
		;
connectAttr "FKShoulder_R_rotate_BakeResults1_inputBZ.o" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.ibz"
		;
connectAttr "BakeResults1.oram" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.acm";
connectAttr "BakeResults1.bgwt" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.wa";
connectAttr "BakeResults1.fgwt" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.wb";
connectAttr "FKShoulder1_R_rotateX.o" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.iax"
		;
connectAttr "FKShoulder1_R_rotateY.o" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.iay"
		;
connectAttr "FKShoulder1_R_rotateZ.o" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.iaz"
		;
connectAttr "FKShoulder1_R_rotateX_BakeResults1_inputB.o" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.ibx"
		;
connectAttr "FKShoulder1_R_rotateY_BakeResults1_inputB.o" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.iby"
		;
connectAttr "FKShoulder1_R_rotate_BakeResults1_inputBZ.o" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.ibz"
		;
connectAttr "BakeResults1.oram" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.acm";
connectAttr "BakeResults1.bgwt" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.wa";
connectAttr "BakeResults1.fgwt" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.wb";
connectAttr "FKElbow_R_rotateX.o" "Sid_Rig:FKElbow_R_rotate_BakeResults1.iax";
connectAttr "FKElbow_R_rotateY.o" "Sid_Rig:FKElbow_R_rotate_BakeResults1.iay";
connectAttr "FKElbow_R_rotateZ.o" "Sid_Rig:FKElbow_R_rotate_BakeResults1.iaz";
connectAttr "FKElbow_R_rotateX_BakeResults1_inputB.o" "Sid_Rig:FKElbow_R_rotate_BakeResults1.ibx"
		;
connectAttr "FKElbow_R_rotateY_BakeResults1_inputB.o" "Sid_Rig:FKElbow_R_rotate_BakeResults1.iby"
		;
connectAttr "FKElbow_R_rotate_BakeResults1_inputBZ.o" "Sid_Rig:FKElbow_R_rotate_BakeResults1.ibz"
		;
connectAttr "BakeResults1.oram" "Sid_Rig:FKElbow_R_rotate_BakeResults1.acm";
connectAttr "BakeResults1.bgwt" "Sid_Rig:FKElbow_R_rotate_BakeResults1.wa";
connectAttr "BakeResults1.fgwt" "Sid_Rig:FKElbow_R_rotate_BakeResults1.wb";
connectAttr "FKElbow1_R_rotateX.o" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.iax";
connectAttr "FKElbow1_R_rotateY.o" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.iay";
connectAttr "FKElbow1_R_rotateZ.o" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.iaz";
connectAttr "FKElbow1_R_rotateX_BakeResults1_inputB.o" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.ibx"
		;
connectAttr "FKElbow1_R_rotateY_BakeResults1_inputB.o" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.iby"
		;
connectAttr "FKElbow1_R_rotate_BakeResults1_inputBZ.o" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.ibz"
		;
connectAttr "BakeResults1.oram" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.acm";
connectAttr "BakeResults1.bgwt" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.wa";
connectAttr "BakeResults1.fgwt" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.wb";
connectAttr "FKWrist_R_rotateX.o" "Sid_Rig:FKWrist_R_rotate_BakeResults1.iax";
connectAttr "FKWrist_R_rotateY.o" "Sid_Rig:FKWrist_R_rotate_BakeResults1.iay";
connectAttr "FKWrist_R_rotateZ.o" "Sid_Rig:FKWrist_R_rotate_BakeResults1.iaz";
connectAttr "FKWrist_R_rotateX_BakeResults1_inputB.o" "Sid_Rig:FKWrist_R_rotate_BakeResults1.ibx"
		;
connectAttr "FKWrist_R_rotateY_BakeResults1_inputB.o" "Sid_Rig:FKWrist_R_rotate_BakeResults1.iby"
		;
connectAttr "FKWrist_R_rotate_BakeResults1_inputBZ.o" "Sid_Rig:FKWrist_R_rotate_BakeResults1.ibz"
		;
connectAttr "BakeResults1.oram" "Sid_Rig:FKWrist_R_rotate_BakeResults1.acm";
connectAttr "BakeResults1.bgwt" "Sid_Rig:FKWrist_R_rotate_BakeResults1.wa";
connectAttr "BakeResults1.fgwt" "Sid_Rig:FKWrist_R_rotate_BakeResults1.wb";
connectAttr "hyperLayout2.msg" "BakeResults1Container.hl";
connectAttr "BakeResults1.msg" "hyperLayout2.hyp[0].dn";
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.msg" "hyperLayout2.hyp[1].dn"
		;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.msg" "hyperLayout2.hyp[2].dn"
		;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.msg" "hyperLayout2.hyp[3].dn"
		;
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.msg" "hyperLayout2.hyp[4].dn"
		;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.msg" "hyperLayout2.hyp[5].dn"
		;
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
// End of Sid_Parry.ma
