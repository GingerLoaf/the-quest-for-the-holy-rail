//Maya ASCII 2023 scene
//Name: Sid_SkateLoop.ma
//Last modified: Mon, Jan 26, 2026 08:57:29 PM
//Codeset: 1252
file -rdi 1 -ns "Sid_Rig" -rfn "Sid_RigRN" -op "v=0;p=17;f=0" -typ "mayaAscii"
		 "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Sid_Rig.ma";
file -r -ns "Sid_Rig" -dr 1 -rfn "Sid_RigRN" -op "v=0;p=17;f=0" -typ "mayaAscii"
		 "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Sid_Rig.ma";
requires maya "2023";
requires -nodeType "polyDisc" "modelingToolkit" "0.0.0.0";
requires "stereoCamera" "10.0";
requires -nodeType "gameFbxExporter" "gameFbxExporter" "1.0";
requires "mtoa" "5.1.0";
requires -nodeType "ilrOptionsNode" -nodeType "ilrUIOptionsNode" -nodeType "ilrBakeLayerManager"
		 -nodeType "ilrBakeLayer" "Turtle" "2023.0.0";
requires "maxwell" "1.0.16";
requires "stereoCamera" "10.0";
currentUnit -l centimeter -a degree -t ntsc;
fileInfo "application" "maya";
fileInfo "product" "Maya 2023";
fileInfo "version" "2023";
fileInfo "cutIdentifier" "202202161415-df43006fd3";
fileInfo "osv" "Windows 11 Pro v2009 (Build: 26200)";
fileInfo "UUID" "DBD00C0E-45B5-3591-38F3-9AA8DD26EF75";
createNode transform -s -n "persp";
	rename -uid "17A9EB17-436B-8560-C8FC-56B4C7CFD8C7";
	setAttr ".v" no;
	setAttr ".t" -type "double3" -260.49228132663222 63.555701320199994 -19.623175712214927 ;
	setAttr ".r" -type "double3" -6.3383528101663185 2428.2000000028679 0 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "9661827E-4C39-453C-5668-8F9539113D52";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 243.72718139895485;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	rename -uid "F8CA06AE-42FD-86F1-40C1-7D8444BEBCB7";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 1000.1 0 ;
	setAttr ".r" -type "double3" -90 0 0 ;
createNode camera -s -n "topShape" -p "top";
	rename -uid "8168E6CA-4E24-9FEE-A2ED-D6B5B9921279";
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
	rename -uid "B18B1190-4AA9-33CB-5990-D6877D5B105A";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 0 1000.1 ;
createNode camera -s -n "frontShape" -p "front";
	rename -uid "5F3313AC-4C31-3199-BB3A-C0B85E19598B";
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
	rename -uid "0FDE5452-4263-EB05-69F0-9C918048CD55";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 1000.1910342363436 13.427216852198086 1.1004796033938056 ;
	setAttr ".r" -type "double3" 0 90 0 ;
createNode camera -s -n "sideShape" -p "side";
	rename -uid "FCCBED5B-49C7-F683-2DC4-5782A366B5BF";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".coi" 996.92984901074658;
	setAttr ".ow" 16.726698114583989;
	setAttr ".imn" -type "string" "side";
	setAttr ".den" -type "string" "side_depth";
	setAttr ".man" -type "string" "side_mask";
	setAttr ".tp" -type "double3" 3.2611852255969973 13.427216852198086 1.1004796033938056 ;
	setAttr ".hc" -type "string" "viewSet -s %camera";
	setAttr ".o" yes;
	setAttr ".ai_translator" -type "string" "orthographic";
createNode transform -n "shotGame_grp";
	rename -uid "BCA1E732-4619-9537-A1E1-758C025489DA";
createNode transform -n "shotCam" -p "shotGame_grp";
	rename -uid "14B016DC-42AE-2A58-C2D5-5AB7168437C1";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
createNode camera -n "shotCamShape" -p "shotCam";
	rename -uid "3A774A42-42C0-A196-CE8C-32B966947894";
	setAttr -k off ".v";
	setAttr ".rnd" no;
	setAttr ".ovr" 1.3;
	setAttr ".fl" 20;
	setAttr ".coi" 8.9375743432580403;
	setAttr ".imn" -type "string" "shotCam1";
	setAttr ".den" -type "string" "shotCam1_depth";
	setAttr ".man" -type "string" "shotCam1_mask";
	setAttr ".dr" yes;
createNode parentConstraint -n "shotCam_parentConstraint1" -p "shotCam";
	rename -uid "F082D6DA-4DE8-547F-01A4-479A40485BEF";
	addAttr -dcb 0 -ci true -k true -sn "w0" -ln "Camera_CTRLW0" -dv 1 -min 0 -at "double";
	setAttr -k on ".nds";
	setAttr -k off ".v";
	setAttr -k off ".tx";
	setAttr -k off ".ty";
	setAttr -k off ".tz";
	setAttr -k off ".rx";
	setAttr -k off ".ry";
	setAttr -k off ".rz";
	setAttr -k off ".sx";
	setAttr -k off ".sy";
	setAttr -k off ".sz";
	setAttr ".erp" yes;
	setAttr ".lr" -type "double3" -14.999999999999982 179.99999999999994 0 ;
	setAttr ".rst" -type "double3" 1.1368683772161594e-13 25.403375649957038 -121.06242964634893 ;
	setAttr ".rsrr" -type "double3" 0 179.99999999999994 0 ;
	setAttr -k on ".w0";
createNode transform -n "pDisc1";
	rename -uid "A2A453D4-4CA3-1318-C7E8-A99C4E924114";
	setAttr ".t" -type "double3" 0 -1.8300777172109841 0 ;
	setAttr ".s" -type "double3" 300 300 300 ;
createNode mesh -n "pDiscShape1" -p "pDisc1";
	rename -uid "1F20024F-46F9-7FBD-C402-F0B2D8B49FCF";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
createNode place3dTexture -n "place3dTexture1";
	rename -uid "DA2C2D91-42D3-C519-3EA3-4C90186ADA30";
createNode lightLinker -s -n "lightLinker1";
	rename -uid "4B046021-4F57-0A41-21B0-FBAA38557B41";
	setAttr -s 86 ".lnk";
	setAttr -s 86 ".slnk";
createNode shapeEditorManager -n "shapeEditorManager";
	rename -uid "12F5265F-4BDD-59B3-1CC3-C9B3686AA621";
createNode poseInterpolatorManager -n "poseInterpolatorManager";
	rename -uid "416D0073-4A53-1DC4-2D4D-5B9AAC15FAA4";
createNode displayLayerManager -n "layerManager";
	rename -uid "08C6188A-4F5E-593B-0AB6-79909AF9E532";
createNode displayLayer -n "defaultLayer";
	rename -uid "0F8EE5ED-4944-9DEC-F574-07AC19A3345B";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "56907095-4F51-ADA3-C9C4-A4A75DAABD44";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "8D100984-452F-9BDE-8619-15B9D4A7F443";
	setAttr ".g" yes;
createNode reference -n "Sid_RigRN";
	rename -uid "17468894-435F-73E5-8943-CBA4E0F68156";
	setAttr ".fn[0]" -type "string" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Sid_Rig.ma";
	setAttr -s 396 ".phl";
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
	setAttr ".ed" -type "dataReferenceEdits" 
		"Sid_RigRN"
		"Sid_RigRN" 0
		"Sid_RigRN" 440
		1 |Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master "blendParent1" "blendParent1" 
		" -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R 
		"blendOrient1" "blendOrient1" " -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		1 |Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R 
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
		2 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master" "blendParent1" " -k 1"
		
		2 "|Sid_Rig:Main" "visibility" " -av 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L" 
		"blendOrient1" " -k 1 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M" 
		"translate" " -type \"double3\" 0 0 0"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M" 
		"FKIKBlend" " -k 1 0"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M" 
		"legLock" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M" 
		"CenterBtwFeet" " -k 1"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"indexCurl" " -k 1 -2"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"middleCurl" " -k 1 -1.20000004768371582"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"pinkyCurl" " -k 1 0.40000003576278687"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"thumbCurl" " -k 1 -2"
		2 "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R" 
		"spread" " -k 1 1.89999997615814209"
		2 "|Sid_Rig:Root" "focal_length" " -k 1 35"
		2 "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL" "translate" " -type \"double3\" 0 65.26829981240750556 108.96789694622854938"
		
		2 "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL" "rotate" " -type \"double3\" -14.99999999999999822 0 0"
		
		2 "Sid_Rig:Mesh" "displayType" " 0"
		2 "Sid_Rig:Mesh" "visibility" " 1"
		2 "Sid_Rig:Mesh" "hideOnPlayback" " 1"
		2 "Sid_Rig:layer1" "visibility" " 1"
		2 "Sid_Rig:layer1" "hideOnPlayback" " 1"
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
		5 4 "Sid_RigRN" "|Sid_Rig:Main.translateX" "Sid_RigRN.placeHolderList[19]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.translateY" "Sid_RigRN.placeHolderList[20]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.translateZ" "Sid_RigRN.placeHolderList[21]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.rotateX" "Sid_RigRN.placeHolderList[22]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.rotateY" "Sid_RigRN.placeHolderList[23]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main.rotateZ" "Sid_RigRN.placeHolderList[24]" 
		""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_R|Sid_Rig:FKOffsetToes_R|Sid_Rig:FKFootRollIKToes_R|Sid_Rig:FKExtraToes_R|Sid_Rig:FKToes_R.rotateX" 
		"Sid_RigRN.placeHolderList[25]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_R|Sid_Rig:FKOffsetToes_R|Sid_Rig:FKFootRollIKToes_R|Sid_Rig:FKExtraToes_R|Sid_Rig:FKToes_R.rotateY" 
		"Sid_RigRN.placeHolderList[26]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_R|Sid_Rig:FKOffsetToes_R|Sid_Rig:FKFootRollIKToes_R|Sid_Rig:FKExtraToes_R|Sid_Rig:FKToes_R.rotateZ" 
		"Sid_RigRN.placeHolderList[27]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.translateX" 
		"Sid_RigRN.placeHolderList[28]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.translateY" 
		"Sid_RigRN.placeHolderList[29]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.translateZ" 
		"Sid_RigRN.placeHolderList[30]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateZ" 
		"Sid_RigRN.placeHolderList[31]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateX" 
		"Sid_RigRN.placeHolderList[32]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateY" 
		"Sid_RigRN.placeHolderList[33]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.translateX" 
		"Sid_RigRN.placeHolderList[34]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.translateY" 
		"Sid_RigRN.placeHolderList[35]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.translateZ" 
		"Sid_RigRN.placeHolderList[36]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.rotateX" 
		"Sid_RigRN.placeHolderList[37]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.rotateY" 
		"Sid_RigRN.placeHolderList[38]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.rotateZ" 
		"Sid_RigRN.placeHolderList[39]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.scaleX" 
		"Sid_RigRN.placeHolderList[40]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.scaleY" 
		"Sid_RigRN.placeHolderList[41]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.scaleZ" 
		"Sid_RigRN.placeHolderList[42]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote02_Ctrl.visibility" 
		"Sid_RigRN.placeHolderList[43]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.translateX" 
		"Sid_RigRN.placeHolderList[44]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.translateY" 
		"Sid_RigRN.placeHolderList[45]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.translateZ" 
		"Sid_RigRN.placeHolderList[46]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.rotateX" 
		"Sid_RigRN.placeHolderList[47]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.rotateY" 
		"Sid_RigRN.placeHolderList[48]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.rotateZ" 
		"Sid_RigRN.placeHolderList[49]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.scaleX" 
		"Sid_RigRN.placeHolderList[50]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.scaleY" 
		"Sid_RigRN.placeHolderList[51]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.scaleZ" 
		"Sid_RigRN.placeHolderList[52]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Bigote01_Ctrl.visibility" 
		"Sid_RigRN.placeHolderList[53]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.translateX" 
		"Sid_RigRN.placeHolderList[54]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.translateY" 
		"Sid_RigRN.placeHolderList[55]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.translateZ" 
		"Sid_RigRN.placeHolderList[56]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateZ" 
		"Sid_RigRN.placeHolderList[57]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateX" 
		"Sid_RigRN.placeHolderList[58]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateY" 
		"Sid_RigRN.placeHolderList[59]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateX" 
		"Sid_RigRN.placeHolderList[60]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateX" 
		"Sid_RigRN.placeHolderList[61]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateY" 
		"Sid_RigRN.placeHolderList[62]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateY" 
		"Sid_RigRN.placeHolderList[63]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateZ" 
		"Sid_RigRN.placeHolderList[64]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateZ" 
		"Sid_RigRN.placeHolderList[65]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[66]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[67]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateX" 
		"Sid_RigRN.placeHolderList[68]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateX" 
		"Sid_RigRN.placeHolderList[69]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateY" 
		"Sid_RigRN.placeHolderList[70]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateY" 
		"Sid_RigRN.placeHolderList[71]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[72]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[73]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[74]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[75]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateX" 
		"Sid_RigRN.placeHolderList[76]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateX" 
		"Sid_RigRN.placeHolderList[77]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateY" 
		"Sid_RigRN.placeHolderList[78]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateY" 
		"Sid_RigRN.placeHolderList[79]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateZ" 
		"Sid_RigRN.placeHolderList[80]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateZ" 
		"Sid_RigRN.placeHolderList[81]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[82]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[83]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateX" 
		"Sid_RigRN.placeHolderList[84]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateX" 
		"Sid_RigRN.placeHolderList[85]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateY" 
		"Sid_RigRN.placeHolderList[86]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateY" 
		"Sid_RigRN.placeHolderList[87]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[88]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[89]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[90]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[91]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateX" 
		"Sid_RigRN.placeHolderList[92]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateX" 
		"Sid_RigRN.placeHolderList[93]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateY" 
		"Sid_RigRN.placeHolderList[94]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateY" 
		"Sid_RigRN.placeHolderList[95]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateZ" 
		"Sid_RigRN.placeHolderList[96]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateZ" 
		"Sid_RigRN.placeHolderList[97]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[98]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.instObjGroups" 
		"Sid_RigRN.placeHolderList[99]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateX" 
		"Sid_RigRN.placeHolderList[100]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateX" 
		"Sid_RigRN.placeHolderList[101]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateY" 
		"Sid_RigRN.placeHolderList[102]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateY" 
		"Sid_RigRN.placeHolderList[103]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateZ" 
		"Sid_RigRN.placeHolderList[104]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateZ" 
		"Sid_RigRN.placeHolderList[105]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[106]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[107]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[108]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateX" 
		"Sid_RigRN.placeHolderList[109]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateX" 
		"Sid_RigRN.placeHolderList[110]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateY" 
		"Sid_RigRN.placeHolderList[111]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateY" 
		"Sid_RigRN.placeHolderList[112]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[113]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateX" 
		"Sid_RigRN.placeHolderList[114]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateX" 
		"Sid_RigRN.placeHolderList[115]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateY" 
		"Sid_RigRN.placeHolderList[116]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateY" 
		"Sid_RigRN.placeHolderList[117]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateZ" 
		"Sid_RigRN.placeHolderList[118]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateZ" 
		"Sid_RigRN.placeHolderList[119]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[120]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateX" 
		"Sid_RigRN.placeHolderList[121]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateX" 
		"Sid_RigRN.placeHolderList[122]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateY" 
		"Sid_RigRN.placeHolderList[123]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateY" 
		"Sid_RigRN.placeHolderList[124]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[125]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[126]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[127]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateX" 
		"Sid_RigRN.placeHolderList[128]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateX" 
		"Sid_RigRN.placeHolderList[129]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateY" 
		"Sid_RigRN.placeHolderList[130]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateY" 
		"Sid_RigRN.placeHolderList[131]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateZ" 
		"Sid_RigRN.placeHolderList[132]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateZ" 
		"Sid_RigRN.placeHolderList[133]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[134]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[135]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[136]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[137]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[138]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[139]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[140]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[141]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[142]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[143]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[144]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[145]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[146]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[147]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[148]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[149]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[150]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[151]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[152]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[153]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[154]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[155]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[156]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[157]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[158]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[159]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[160]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[161]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[162]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[163]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[164]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[165]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[166]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[167]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[168]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[169]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[170]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M.translateX" 
		"Sid_RigRN.placeHolderList[171]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M.translateY" 
		"Sid_RigRN.placeHolderList[172]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M.translateZ" 
		"Sid_RigRN.placeHolderList[173]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M.rotateX" 
		"Sid_RigRN.placeHolderList[174]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M.rotateY" 
		"Sid_RigRN.placeHolderList[175]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M.rotateZ" 
		"Sid_RigRN.placeHolderList[176]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M.translateX" 
		"Sid_RigRN.placeHolderList[177]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M.translateY" 
		"Sid_RigRN.placeHolderList[178]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M.translateZ" 
		"Sid_RigRN.placeHolderList[179]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M.rotateX" 
		"Sid_RigRN.placeHolderList[180]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M.rotateY" 
		"Sid_RigRN.placeHolderList[181]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M.rotateZ" 
		"Sid_RigRN.placeHolderList[182]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateX" 
		"Sid_RigRN.placeHolderList[183]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateY" 
		"Sid_RigRN.placeHolderList[184]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateZ" 
		"Sid_RigRN.placeHolderList[185]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateX" 
		"Sid_RigRN.placeHolderList[186]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateY" 
		"Sid_RigRN.placeHolderList[187]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateZ" 
		"Sid_RigRN.placeHolderList[188]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M.translateX" 
		"Sid_RigRN.placeHolderList[189]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M.translateY" 
		"Sid_RigRN.placeHolderList[190]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M.translateZ" 
		"Sid_RigRN.placeHolderList[191]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M.rotateX" 
		"Sid_RigRN.placeHolderList[192]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M.rotateY" 
		"Sid_RigRN.placeHolderList[193]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M.rotateZ" 
		"Sid_RigRN.placeHolderList[194]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M.translateX" 
		"Sid_RigRN.placeHolderList[195]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M.translateY" 
		"Sid_RigRN.placeHolderList[196]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M.translateZ" 
		"Sid_RigRN.placeHolderList[197]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M.rotateX" 
		"Sid_RigRN.placeHolderList[198]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M.rotateY" 
		"Sid_RigRN.placeHolderList[199]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M.rotateZ" 
		"Sid_RigRN.placeHolderList[200]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateX" 
		"Sid_RigRN.placeHolderList[201]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateY" 
		"Sid_RigRN.placeHolderList[202]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateZ" 
		"Sid_RigRN.placeHolderList[203]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateX" 
		"Sid_RigRN.placeHolderList[204]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateY" 
		"Sid_RigRN.placeHolderList[205]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateZ" 
		"Sid_RigRN.placeHolderList[206]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateX" 
		"Sid_RigRN.placeHolderList[207]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateY" 
		"Sid_RigRN.placeHolderList[208]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateZ" 
		"Sid_RigRN.placeHolderList[209]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateX" 
		"Sid_RigRN.placeHolderList[210]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateY" 
		"Sid_RigRN.placeHolderList[211]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateZ" 
		"Sid_RigRN.placeHolderList[212]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[213]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[214]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[215]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[216]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[217]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[218]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[219]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[220]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[221]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[222]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[223]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[224]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[225]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[226]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[227]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[228]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[229]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[230]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[231]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[232]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[233]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[234]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[235]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[236]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[237]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[238]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[239]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[240]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[241]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[242]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[243]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[244]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[245]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[246]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[247]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[248]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateX" 
		"Sid_RigRN.placeHolderList[249]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateY" 
		"Sid_RigRN.placeHolderList[250]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateZ" 
		"Sid_RigRN.placeHolderList[251]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.stabilize" 
		"Sid_RigRN.placeHolderList[252]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine1_M|Sid_Rig:IKExtraSpine1_M|Sid_Rig:IKSpine1_M.translateX" 
		"Sid_RigRN.placeHolderList[253]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine1_M|Sid_Rig:IKExtraSpine1_M|Sid_Rig:IKSpine1_M.translateY" 
		"Sid_RigRN.placeHolderList[254]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine1_M|Sid_Rig:IKExtraSpine1_M|Sid_Rig:IKSpine1_M.translateZ" 
		"Sid_RigRN.placeHolderList[255]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine1_M|Sid_Rig:IKExtraSpine1_M|Sid_Rig:IKSpine1_M.rotateX" 
		"Sid_RigRN.placeHolderList[256]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine1_M|Sid_Rig:IKExtraSpine1_M|Sid_Rig:IKSpine1_M.rotateY" 
		"Sid_RigRN.placeHolderList[257]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine1_M|Sid_Rig:IKExtraSpine1_M|Sid_Rig:IKSpine1_M.rotateZ" 
		"Sid_RigRN.placeHolderList[258]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine2_M|Sid_Rig:IKExtraSpine2_M|Sid_Rig:IKSpine2_M.translateX" 
		"Sid_RigRN.placeHolderList[259]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine2_M|Sid_Rig:IKExtraSpine2_M|Sid_Rig:IKSpine2_M.translateY" 
		"Sid_RigRN.placeHolderList[260]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine2_M|Sid_Rig:IKExtraSpine2_M|Sid_Rig:IKSpine2_M.translateZ" 
		"Sid_RigRN.placeHolderList[261]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine2_M|Sid_Rig:IKExtraSpine2_M|Sid_Rig:IKSpine2_M.rotateX" 
		"Sid_RigRN.placeHolderList[262]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine2_M|Sid_Rig:IKExtraSpine2_M|Sid_Rig:IKSpine2_M.rotateY" 
		"Sid_RigRN.placeHolderList[263]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKRootConstraint|Sid_Rig:IKOffsetSpine2_M|Sid_Rig:IKExtraSpine2_M|Sid_Rig:IKSpine2_M.rotateZ" 
		"Sid_RigRN.placeHolderList[264]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateX" 
		"Sid_RigRN.placeHolderList[265]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateY" 
		"Sid_RigRN.placeHolderList[266]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateZ" 
		"Sid_RigRN.placeHolderList[267]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateY" 
		"Sid_RigRN.placeHolderList[268]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateX" 
		"Sid_RigRN.placeHolderList[269]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateZ" 
		"Sid_RigRN.placeHolderList[270]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.toe" 
		"Sid_RigRN.placeHolderList[271]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rollAngle" 
		"Sid_RigRN.placeHolderList[272]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.roll" 
		"Sid_RigRN.placeHolderList[273]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.stretchy" 
		"Sid_RigRN.placeHolderList[274]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.antiPop" 
		"Sid_RigRN.placeHolderList[275]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght1" 
		"Sid_RigRN.placeHolderList[276]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght2" 
		"Sid_RigRN.placeHolderList[277]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.volume" 
		"Sid_RigRN.placeHolderList[278]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateX" 
		"Sid_RigRN.placeHolderList[279]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateY" 
		"Sid_RigRN.placeHolderList[280]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateZ" 
		"Sid_RigRN.placeHolderList[281]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.visibility" 
		"Sid_RigRN.placeHolderList[282]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateX" 
		"Sid_RigRN.placeHolderList[283]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateY" 
		"Sid_RigRN.placeHolderList[284]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateZ" 
		"Sid_RigRN.placeHolderList[285]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleX" 
		"Sid_RigRN.placeHolderList[286]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleY" 
		"Sid_RigRN.placeHolderList[287]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleZ" 
		"Sid_RigRN.placeHolderList[288]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateX" 
		"Sid_RigRN.placeHolderList[289]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateY" 
		"Sid_RigRN.placeHolderList[290]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateZ" 
		"Sid_RigRN.placeHolderList[291]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.visibility" 
		"Sid_RigRN.placeHolderList[292]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateX" 
		"Sid_RigRN.placeHolderList[293]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateY" 
		"Sid_RigRN.placeHolderList[294]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateZ" 
		"Sid_RigRN.placeHolderList[295]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleX" 
		"Sid_RigRN.placeHolderList[296]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleY" 
		"Sid_RigRN.placeHolderList[297]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleZ" 
		"Sid_RigRN.placeHolderList[298]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateZ" 
		"Sid_RigRN.placeHolderList[299]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateX" 
		"Sid_RigRN.placeHolderList[300]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateY" 
		"Sid_RigRN.placeHolderList[301]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateX" 
		"Sid_RigRN.placeHolderList[302]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateY" 
		"Sid_RigRN.placeHolderList[303]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateZ" 
		"Sid_RigRN.placeHolderList[304]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.visibility" 
		"Sid_RigRN.placeHolderList[305]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleX" 
		"Sid_RigRN.placeHolderList[306]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleY" 
		"Sid_RigRN.placeHolderList[307]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleZ" 
		"Sid_RigRN.placeHolderList[308]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateX" 
		"Sid_RigRN.placeHolderList[309]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateY" 
		"Sid_RigRN.placeHolderList[310]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateZ" 
		"Sid_RigRN.placeHolderList[311]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.follow" 
		"Sid_RigRN.placeHolderList[312]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.lock" 
		"Sid_RigRN.placeHolderList[313]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateX" 
		"Sid_RigRN.placeHolderList[314]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateY" 
		"Sid_RigRN.placeHolderList[315]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateZ" 
		"Sid_RigRN.placeHolderList[316]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateX" 
		"Sid_RigRN.placeHolderList[317]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateY" 
		"Sid_RigRN.placeHolderList[318]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateZ" 
		"Sid_RigRN.placeHolderList[319]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.toe" 
		"Sid_RigRN.placeHolderList[320]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rollAngle" 
		"Sid_RigRN.placeHolderList[321]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.roll" 
		"Sid_RigRN.placeHolderList[322]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.stretchy" 
		"Sid_RigRN.placeHolderList[323]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.antiPop" 
		"Sid_RigRN.placeHolderList[324]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght1" 
		"Sid_RigRN.placeHolderList[325]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght2" 
		"Sid_RigRN.placeHolderList[326]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.volume" 
		"Sid_RigRN.placeHolderList[327]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateX" 
		"Sid_RigRN.placeHolderList[328]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateY" 
		"Sid_RigRN.placeHolderList[329]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateZ" 
		"Sid_RigRN.placeHolderList[330]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.visibility" 
		"Sid_RigRN.placeHolderList[331]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateX" 
		"Sid_RigRN.placeHolderList[332]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateY" 
		"Sid_RigRN.placeHolderList[333]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateZ" 
		"Sid_RigRN.placeHolderList[334]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleX" 
		"Sid_RigRN.placeHolderList[335]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleY" 
		"Sid_RigRN.placeHolderList[336]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleZ" 
		"Sid_RigRN.placeHolderList[337]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateX" 
		"Sid_RigRN.placeHolderList[338]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateY" 
		"Sid_RigRN.placeHolderList[339]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateZ" 
		"Sid_RigRN.placeHolderList[340]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.visibility" 
		"Sid_RigRN.placeHolderList[341]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateX" 
		"Sid_RigRN.placeHolderList[342]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateY" 
		"Sid_RigRN.placeHolderList[343]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateZ" 
		"Sid_RigRN.placeHolderList[344]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleX" 
		"Sid_RigRN.placeHolderList[345]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleY" 
		"Sid_RigRN.placeHolderList[346]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleZ" 
		"Sid_RigRN.placeHolderList[347]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateZ" 
		"Sid_RigRN.placeHolderList[348]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateX" 
		"Sid_RigRN.placeHolderList[349]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateY" 
		"Sid_RigRN.placeHolderList[350]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateX" 
		"Sid_RigRN.placeHolderList[351]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateY" 
		"Sid_RigRN.placeHolderList[352]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateZ" 
		"Sid_RigRN.placeHolderList[353]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.visibility" 
		"Sid_RigRN.placeHolderList[354]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleX" 
		"Sid_RigRN.placeHolderList[355]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleY" 
		"Sid_RigRN.placeHolderList[356]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleZ" 
		"Sid_RigRN.placeHolderList[357]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateX" 
		"Sid_RigRN.placeHolderList[358]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateY" 
		"Sid_RigRN.placeHolderList[359]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateZ" 
		"Sid_RigRN.placeHolderList[360]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.follow" 
		"Sid_RigRN.placeHolderList[361]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.lock" 
		"Sid_RigRN.placeHolderList[362]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.FKIKBlend" 
		"Sid_RigRN.placeHolderList[363]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.IKVis" 
		"Sid_RigRN.placeHolderList[364]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.FKVis" 
		"Sid_RigRN.placeHolderList[365]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.FKIKBlend" 
		"Sid_RigRN.placeHolderList[366]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.IKVis" 
		"Sid_RigRN.placeHolderList[367]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.FKVis" 
		"Sid_RigRN.placeHolderList[368]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.IKVis" 
		"Sid_RigRN.placeHolderList[369]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.FKVis" 
		"Sid_RigRN.placeHolderList[370]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.FKIKBlend" 
		"Sid_RigRN.placeHolderList[371]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.IKVis" 
		"Sid_RigRN.placeHolderList[372]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.FKVis" 
		"Sid_RigRN.placeHolderList[373]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.FKIKBlend" 
		"Sid_RigRN.placeHolderList[374]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.IKVis" 
		"Sid_RigRN.placeHolderList[375]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.FKVis" 
		"Sid_RigRN.placeHolderList[376]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateX" 
		"Sid_RigRN.placeHolderList[377]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateY" 
		"Sid_RigRN.placeHolderList[378]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateZ" 
		"Sid_RigRN.placeHolderList[379]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.legLock" 
		"Sid_RigRN.placeHolderList[380]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.CenterBtwFeet" 
		"Sid_RigRN.placeHolderList[381]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateX" 
		"Sid_RigRN.placeHolderList[382]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateY" 
		"Sid_RigRN.placeHolderList[383]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateZ" 
		"Sid_RigRN.placeHolderList[384]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.indexCurl" 
		"Sid_RigRN.placeHolderList[385]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.middleCurl" 
		"Sid_RigRN.placeHolderList[386]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.pinkyCurl" 
		"Sid_RigRN.placeHolderList[387]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.thumbCurl" 
		"Sid_RigRN.placeHolderList[388]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.spread" 
		"Sid_RigRN.placeHolderList[389]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL.translate" 
		"Sid_RigRN.placeHolderList[390]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL.rotatePivot" 
		"Sid_RigRN.placeHolderList[391]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL.rotatePivotTranslate" 
		"Sid_RigRN.placeHolderList[392]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL.rotate" 
		"Sid_RigRN.placeHolderList[393]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL.rotateOrder" 
		"Sid_RigRN.placeHolderList[394]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL.scale" 
		"Sid_RigRN.placeHolderList[395]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Camera_CTRL_grp|Sid_Rig:Camera_CTRL.parentMatrix" 
		"Sid_RigRN.placeHolderList[396]" "";
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
createNode reference -n "sharedReferenceNode";
	rename -uid "30DB293C-428B-BB52-8F2E-A5B773DA0023";
	setAttr ".ed" -type "dataReferenceEdits" 
		"sharedReferenceNode";
createNode script -n "uiConfigurationScriptNode";
	rename -uid "26515458-4ECA-44FE-32CD-3787E53FE066";
	setAttr ".b" -type "string" (
		"// Maya Mel UI Configuration File.\n//\n//  This script is machine generated.  Edit at your own risk.\n//\n//\n\nglobal string $gMainPane;\nif (`paneLayout -exists $gMainPane`) {\n\n\tglobal int $gUseScenePanelConfig;\n\tint    $useSceneConfig = $gUseScenePanelConfig;\n\tint    $nodeEditorPanelVisible = stringArrayContains(\"nodeEditorPanel1\", `getPanel -vis`);\n\tint    $nodeEditorWorkspaceControlOpen = (`workspaceControl -exists nodeEditorPanel1Window` && `workspaceControl -q -visible nodeEditorPanel1Window`);\n\tint    $menusOkayInPanels = `optionVar -q allowMenusInPanels`;\n\tint    $nVisPanes = `paneLayout -q -nvp $gMainPane`;\n\tint    $nPanes = 0;\n\tstring $editorName;\n\tstring $panelName;\n\tstring $itemFilterName;\n\tstring $panelConfig;\n\n\t//\n\t//  get current state of the UI\n\t//\n\tsceneUIReplacement -update $gMainPane;\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Top View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|persp\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 1\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n"
		+ "            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -controllers 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n"
		+ "            -hulls 1\n            -grid 0\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 2485\n            -height 1083\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n"
		+ "\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Side View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|side\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n"
		+ "            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n"
		+ "            -sortTransparent 1\n            -controllers 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 481\n            -height 0\n"
		+ "            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Front View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|front\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n"
		+ "            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n"
		+ "            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -controllers 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n"
		+ "            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 482\n            -height 0\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Persp View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|persp\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n"
		+ "            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 1\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n"
		+ "            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -controllers 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 0\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n"
		+ "            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 481\n            -height 839\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"ToggledOutliner\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"ToggledOutliner\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -docTag \"isolOutln_fromSeln\" \n            -showShapes 0\n            -showAssignedMaterials 0\n            -showTimeEditor 1\n            -showReferenceNodes 1\n            -showReferenceMembers 1\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -organizeByClip 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showParentContainers 0\n            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUpstreamCurves 1\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n"
		+ "            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n            -showSetMembers 1\n            -allowMultiSelection 1\n            -alwaysToggleSelect 0\n            -directSelect 0\n            -isSet 0\n            -isSetMember 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n            -niceNames 1\n            -showNamespace 1\n            -showPinIcons 0\n            -mapMotionTrails 0\n            -ignoreHiddenAttribute 0\n            -ignoreOutlinerColor 0\n            -renderFilterVisible 0\n            -renderFilterIndex 0\n            -selectionOrder \"chronological\" \n"
		+ "            -expandAttribute 0\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"Outliner\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -showShapes 0\n            -showAssignedMaterials 0\n            -showTimeEditor 1\n            -showReferenceNodes 0\n            -showReferenceMembers 0\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -organizeByClip 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showParentContainers 0\n"
		+ "            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUpstreamCurves 1\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n            -showSetMembers 1\n            -allowMultiSelection 1\n            -alwaysToggleSelect 0\n            -directSelect 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n"
		+ "            -niceNames 1\n            -showNamespace 1\n            -showPinIcons 0\n            -mapMotionTrails 0\n            -ignoreHiddenAttribute 0\n            -ignoreOutlinerColor 0\n            -renderFilterVisible 0\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"graphEditor\" (localizedPanelLabel(\"Graph Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showTimeEditor 1\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -organizeByClip 1\n"
		+ "                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showParentContainers 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n"
		+ "                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayValues 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showPlayRangeShades \"on\" \n                -lockPlayRangeShades \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1.25\n                -resultScreenSamples 0\n"
		+ "                -resultUpdate \"delayed\" \n                -showUpstreamCurves 1\n                -keyMinScale 1\n                -stackedCurvesMin -1\n                -stackedCurvesMax 1\n                -stackedCurvesSpace 0.2\n                -preSelectionHighlight 0\n                -constrainDrag 0\n                -valueLinesToggle 1\n                -outliner \"graphEditor1OutlineEd\" \n                -highlightAffectedCurves 0\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dopeSheetPanel\" (localizedPanelLabel(\"Dope Sheet\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showTimeEditor 1\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n"
		+ "                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -organizeByClip 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showParentContainers 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n"
		+ "                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayValues 0\n                -snapTime \"integer\" \n"
		+ "                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"timeEditorPanel\" (localizedPanelLabel(\"Time Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Time Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"clipEditorPanel\" (localizedPanelLabel(\"Trax Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n"
		+ "            clipEditor -e \n                -displayValues 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 0 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"sequenceEditorPanel\" (localizedPanelLabel(\"Camera Sequencer\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Camera Sequencer\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = sequenceEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayValues 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -initialized 0\n                -manageSequencer 1 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperGraphPanel\" (localizedPanelLabel(\"Hypergraph Hierarchy\")) `;\n"
		+ "\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypergraph Hierarchy\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"HyperGraphEd\");\n            hyperGraph -e \n                -graphLayoutStyle \"hierarchicalLayout\" \n                -orientation \"horiz\" \n                -mergeConnections 0\n                -zoom 1\n                -animateTransition 0\n                -showRelationships 1\n                -showShapes 0\n                -showDeformers 0\n                -showExpressions 0\n                -showConstraints 0\n                -showConnectionFromSelected 0\n                -showConnectionToSelected 0\n                -showConstraintLabels 0\n                -showUnderworld 0\n                -showInvisible 0\n                -transitionFrames 1\n                -opaqueContainers 0\n                -freeform 0\n                -imagePosition 0 0 \n                -imageScale 1\n                -imageEnabled 0\n                -graphType \"DAG\" \n"
		+ "                -heatMapDisplay 0\n                -updateSelection 1\n                -updateNodeAdded 1\n                -useDrawOverrideColor 0\n                -limitGraphTraversal -1\n                -range 0 0 \n                -iconSize \"smallIcons\" \n                -showCachedConnections 0\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperShadePanel\" (localizedPanelLabel(\"Hypershade\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"visorPanel\" (localizedPanelLabel(\"Visor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Visor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n"
		+ "\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"nodeEditorPanel\" (localizedPanelLabel(\"Node Editor\")) `;\n\tif ($nodeEditorPanelVisible || $nodeEditorWorkspaceControlOpen) {\n\t\tif (\"\" == $panelName) {\n\t\t\tif ($useSceneConfig) {\n\t\t\t\t$panelName = `scriptedPanel -unParent  -type \"nodeEditorPanel\" -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -consistentNameSize 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n                -connectNodeOnCreation 0\n                -connectOnDrop 0\n                -copyConnectionsOnPaste 0\n                -connectionStyle \"bezier\" \n                -defaultPinnedState 0\n                -additiveGraphingMode 0\n                -connectedGraphingMode 1\n                -settingsChangedCallback \"nodeEdSyncControls\" \n                -traversalDepthLimit -1\n"
		+ "                -keyPressCommand \"nodeEdKeyPressCommand\" \n                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -crosshairOnEdgeDragging 0\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                -showUnitConversions 0\n                -editorMode \"default\" \n                -hasWatchpoint 0\n                $editorName;\n\t\t\t}\n\t\t} else {\n\t\t\t$label = `panel -q -label $panelName`;\n\t\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -consistentNameSize 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n"
		+ "                -connectNodeOnCreation 0\n                -connectOnDrop 0\n                -copyConnectionsOnPaste 0\n                -connectionStyle \"bezier\" \n                -defaultPinnedState 0\n                -additiveGraphingMode 0\n                -connectedGraphingMode 1\n                -settingsChangedCallback \"nodeEdSyncControls\" \n                -traversalDepthLimit -1\n                -keyPressCommand \"nodeEdKeyPressCommand\" \n                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -crosshairOnEdgeDragging 0\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                -showUnitConversions 0\n                -editorMode \"default\" \n                -hasWatchpoint 0\n                $editorName;\n\t\t\tif (!$useSceneConfig) {\n"
		+ "\t\t\t\tpanel -e -l $label $panelName;\n\t\t\t}\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"createNodePanel\" (localizedPanelLabel(\"Create Node\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Create Node\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"polyTexturePlacementPanel\" (localizedPanelLabel(\"UV Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"UV Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"renderWindowPanel\" (localizedPanelLabel(\"Render View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Render View\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"shapePanel\" (localizedPanelLabel(\"Shape Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tshapePanel -edit -l (localizedPanelLabel(\"Shape Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"posePanel\" (localizedPanelLabel(\"Pose Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tposePanel -edit -l (localizedPanelLabel(\"Pose Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynRelEdPanel\" (localizedPanelLabel(\"Dynamic Relationships\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dynamic Relationships\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"relationshipPanel\" (localizedPanelLabel(\"Relationship Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Relationship Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"referenceEditorPanel\" (localizedPanelLabel(\"Reference Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Reference Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynPaintScriptedPanelType\" (localizedPanelLabel(\"Paint Effects\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Paint Effects\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"scriptEditorPanel\" (localizedPanelLabel(\"Script Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Script Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"profilerPanel\" (localizedPanelLabel(\"Profiler Tool\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Profiler Tool\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"contentBrowserPanel\" (localizedPanelLabel(\"Content Browser\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Content Browser\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"Stereo\" (localizedPanelLabel(\"Stereo\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Stereo\")) -mbv $menusOkayInPanels  $panelName;\n{ string $editorName = ($panelName+\"Editor\");\n            stereoCameraView -e \n                -camera \"|:persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"wireframe\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -holdOuts 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 1\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n"
		+ "                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 32768\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -depthOfFieldPreview 1\n                -maxConstantTransparency 1\n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n"
		+ "                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -controllers 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n"
		+ "                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 0\n                -shadows 0\n                -captureSequenceNumber -1\n                -width 0\n                -height 0\n                -sceneRenderFilter 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                -useCustomBackground 1\n                $editorName;\n            stereoCameraView -e -viewSelected 0 $editorName;\n            stereoCameraView -e \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                $editorName; };\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\tif ($useSceneConfig) {\n        string $configName = `getPanel -cwl (localizedPanelLabel(\"Current Layout\"))`;\n        if (\"\" != $configName) {\n\t\t\tpanelConfiguration -edit -label (localizedPanelLabel(\"Current Layout\")) \n"
		+ "\t\t\t\t-userCreated false\n\t\t\t\t-defaultImage \"vacantCell.xP:/\"\n\t\t\t\t-image \"\"\n\t\t\t\t-sc false\n\t\t\t\t-configString \"global string $gMainPane; paneLayout -e -cn \\\"single\\\" -ps 1 100 100 $gMainPane;\"\n\t\t\t\t-removeAllPanels\n\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Top View\")) \n\t\t\t\t\t\"modelPanel\"\n"
		+ "\t\t\t\t\t\"$panelName = `modelPanel -unParent -l (localizedPanelLabel(\\\"Top View\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -camera \\\"|persp\\\" \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 1\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -controllers 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 0\\n    -imagePlane 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 1\\n    -clipGhosts 1\\n    -greasePencils 0\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 2485\\n    -height 1083\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t\t\"modelPanel -edit -l (localizedPanelLabel(\\\"Top View\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -camera \\\"|persp\\\" \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 1\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -controllers 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 1\\n    -hulls 1\\n    -grid 0\\n    -imagePlane 1\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 1\\n    -fluids 1\\n    -hairSystems 1\\n    -follicles 1\\n    -nCloths 1\\n    -nParticles 1\\n    -nRigids 1\\n    -dynamicConstraints 1\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 1\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 1\\n    -clipGhosts 1\\n    -greasePencils 0\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 2485\\n    -height 1083\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t$configName;\n\n            setNamedPanelLayout (localizedPanelLabel(\"Current Layout\"));\n        }\n\n        panelHistory -e -clear mainPanelHistory;\n        sceneUIReplacement -clear;\n\t}\n\n\ngrid -spacing 5 -size 12 -divisions 5 -displayAxes yes -displayGridLines yes -displayDivisionLines yes -displayPerspectiveLabels no -displayOrthographicLabels no -displayAxesBold yes -perspectiveLabelPosition axis -orthographicLabelPosition edge;\nviewManip -drawCompass 0 -compassAngle 0 -frontParameters \"\" -homeParameters \"\" -selectionLockParameters \"\";\n}\n");
	setAttr ".st" 3;
createNode script -n "sceneConfigurationScriptNode";
	rename -uid "E363DAC5-44A1-99BB-035D-9484CBB74E1C";
	setAttr ".b" -type "string" "playbackOptions -min 0 -max 26 -ast 0 -aet 26 ";
	setAttr ".st" 6;
createNode pairBlend -n "pairBlend1";
	rename -uid "A0A568CC-46A6-DAED-5F74-708AA8D4E027";
createNode animCurveTL -n "pairBlend1_inTranslateX1";
	rename -uid "8F5621D8-45D1-44CD-A7B9-91915D6CD3FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 -0.36504403518907946 13 -0.36504403518907946
		 26 -0.36504403518907946;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "pairBlend1_inTranslateY1";
	rename -uid "DC2F4A26-4B2A-8AB5-E0B9-80830E056B67";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 -11.810777230760515 13 -11.810777230760515
		 26 -11.810777230760515;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "pairBlend1_inTranslateZ1";
	rename -uid "BFDE4A2B-4ACA-AD01-83A7-CE89EB6CDE39";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 7.4329404525933231 13 7.4329404525933231
		 26 7.4329404525933231;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Main_translateX";
	rename -uid "0AC2F0B0-459C-46E3-4CEB-288933E286E8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Main_translateY";
	rename -uid "BFA2D644-4ED4-6E7E-5EA9-1B9C82B343B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Main_translateZ";
	rename -uid "328A19BB-41C5-E1BD-E03F-FDAE94140A60";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKHead_M_translateX";
	rename -uid "73530E34-4609-AC41-68A6-BE8AA922F80F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 1 0 9 0 15 0 26 0;
	setAttr -s 5 ".kit[3:4]"  1 18;
	setAttr -s 5 ".kot[3:4]"  1 18;
	setAttr -s 5 ".kix[3:4]"  1 1;
	setAttr -s 5 ".kiy[3:4]"  0 0;
	setAttr -s 5 ".kox[3:4]"  1 1;
	setAttr -s 5 ".koy[3:4]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKHead_M_translateY";
	rename -uid "C10DEAA1-49DD-A40D-8A66-5C86C2C9A6D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 1 0 9 0 15 0 26 0;
	setAttr -s 5 ".kit[3:4]"  1 18;
	setAttr -s 5 ".kot[3:4]"  1 18;
	setAttr -s 5 ".kix[3:4]"  1 1;
	setAttr -s 5 ".kiy[3:4]"  0 0;
	setAttr -s 5 ".kox[3:4]"  1 1;
	setAttr -s 5 ".koy[3:4]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKHead_M_translateZ";
	rename -uid "56FCABE7-4E8F-319F-D939-15A50EFEE911";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 1 0 9 0 15 0 26 0;
	setAttr -s 5 ".kit[3:4]"  1 18;
	setAttr -s 5 ".kot[3:4]"  1 18;
	setAttr -s 5 ".kix[3:4]"  1 1;
	setAttr -s 5 ".kiy[3:4]"  0 0;
	setAttr -s 5 ".kox[3:4]"  1 1;
	setAttr -s 5 ".koy[3:4]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Bigote01_Ctrl_translateX";
	rename -uid "14DDD40B-4AD1-D33B-4DAF-8EAF63745B64";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Bigote01_Ctrl_translateY";
	rename -uid "255F3B0E-43B7-622A-D959-AE8C69C77B32";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Bigote01_Ctrl_translateZ";
	rename -uid "07E00EE1-403B-711E-B1CE-3E99635CA64A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Bigote02_Ctrl_translateX";
	rename -uid "82E6969E-4030-12E1-3A21-EFA2427659C0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Bigote02_Ctrl_translateY";
	rename -uid "882F708D-4CCF-294E-99FF-A89315EDEEB5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Bigote02_Ctrl_translateZ";
	rename -uid "978D3BC1-4967-6FC6-A831-639776CD0EAF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Gorro_Ctrl_translateX";
	rename -uid "D6B38012-4216-31E1-23DC-91979ABF06E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Gorro_Ctrl_translateY";
	rename -uid "CD942B04-4F4D-2076-E36E-35894CB22B45";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "Gorro_Ctrl_translateZ";
	rename -uid "A59B6983-4419-E095-F919-37A5CCFD6A96";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "IKLeg_L_translateX";
	rename -uid "6045523E-4237-821A-DD29-FFB88E63073B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 10 ".ktv[0:9]"  0 9.1078056286567293 6 9.1078056286567293
		 7 2.104498954638732 9 -0.8523705203865144 13 2.7305457222764526 20 2.7305457222764526
		 22 -0.8523705203865144 23 9.2083793693860159 24 11.336264533144755 26 9.1078056286567293;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "IKLeg_L_translateY";
	rename -uid "B53646AB-449E-EF69-14EB-E9AD8D4C07DD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 5.8327471230229939 6 5.8327471230229939
		 9 0 13 0 22 0 24 3.7321870760813072 26 5.8327471230229939;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "IKLeg_L_translateZ";
	rename -uid "E3FBC9EA-4B35-D468-7354-69BFF1A45545";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  0 -20.0664369148685 6 -20.874710067032279
		 9 0 13 0 22 0 23 -2.0247968069726499 24 -16.606478117568145 26 -20.0664369148685;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollHeel_L_translateX";
	rename -uid "6A3696D1-4D5D-32BF-D827-888F0736C853";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollHeel_L_translateY";
	rename -uid "3C85C8B7-419D-074E-1C80-0AB115DEB44E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollHeel_L_translateZ";
	rename -uid "F3328B14-4162-DCDE-89E6-52B3FC14E7C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToesEnd_L_translateX";
	rename -uid "0E5B7D92-4494-D741-8E7B-20BC92D3A7F8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToesEnd_L_translateY";
	rename -uid "4AEB164D-44CC-68AE-69D0-15A5A838CA96";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToesEnd_L_translateZ";
	rename -uid "BD58CD48-4CD7-1633-AE92-FB9C57E783C5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToes_L_translateX";
	rename -uid "169DE10B-4474-F68B-5C25-65A910AF19A1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToes_L_translateY";
	rename -uid "5BAD9A9E-4931-A2FA-FD7A-BDA9BB433A62";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToes_L_translateZ";
	rename -uid "4B6E6A4C-444F-5143-E9DC-E79F6D6F3649";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "IKLeg_R_translateX";
	rename -uid "5083FA50-41DA-D78D-D37D-4B870EDF5F24";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 11 ".ktv[0:10]"  0 -4.1377456046781127 7 -4.1377456046781127
		 9 0 10 -7.5433320393854242 11 -12.575387226085535 13 -12.710178971015997 19 -12.710178971015997
		 20 -7.1279271484014064 21 -1.541368879437365 22 0 26 -4.1377456046781127;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "IKLeg_R_translateY";
	rename -uid "6D77D03A-492B-489A-5C0E-9C844C72D9C7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 0 9 0 10 2.5951699067611615 11 2.8480559158765448
		 13 3.4759612694309201 19 3.4759612694309201 20 3.8662945717331993 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "IKLeg_R_translateZ";
	rename -uid "03FA91E8-4BB1-B6C1-2AA5-D3B97C6E025C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  0 0 9 0 10 -5.6881543698551411 11 -13.20188598961958
		 13 -18.347812306399554 19 -18.347812306399554 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollHeel_R_translateX";
	rename -uid "A291F954-46F6-F49F-095D-5D9666AF943C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollHeel_R_translateY";
	rename -uid "460CA415-4857-B6C7-2D55-9990DC999139";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollHeel_R_translateZ";
	rename -uid "C04167B1-43A4-1A7B-E0F1-95B75A690990";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToesEnd_R_translateX";
	rename -uid "A0143CFD-495E-50EF-8734-52B9F767EA54";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToesEnd_R_translateY";
	rename -uid "4C7CA99F-48E3-1EA1-0F48-529AB034BA4A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToesEnd_R_translateZ";
	rename -uid "CA4B54EF-42AC-BABA-5F8E-39A990D6BA21";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToes_R_translateX";
	rename -uid "6AB5973D-472B-D8B6-2A8E-3887F6D014F6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToes_R_translateY";
	rename -uid "BE8AB9B3-4396-291B-56AD-A2B19F4AEF67";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RollToes_R_translateZ";
	rename -uid "014A725D-4289-8EC2-B634-F3BF7CA582A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "PoleLeg_L_translateX";
	rename -uid "456D2556-4A71-AAFC-E35A-189830267B79";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 -2.0555156906213896 6 -2.0555156906213896
		 13 -4.5551739141298642 22 -1.9865209755090207 26 -2.0555156906213896;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "PoleLeg_L_translateY";
	rename -uid "D8A4678E-4F6C-57B9-35DB-CE9D7880626A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 -1.3791729546188682 6 -1.3791729546188682
		 13 2.6453614149041202 22 2.8502918635846464 26 -1.3791729546188682;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "PoleLeg_L_translateZ";
	rename -uid "4E6EB45A-4C94-972B-4B32-A18F4E6AF54A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 -5.3266933363678559 6 -5.3266933363678559
		 13 0.035263774089930658 22 0.027881455125021572 26 -5.3266933363678559;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "PoleLeg_R_translateX";
	rename -uid "A3051564-4F9B-F7B5-6E85-828CE945CA77";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 3.4184563913594959 9 2.1724067085154206
		 13 0 22 2.0410978165123481 26 3.4184563913594959;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "PoleLeg_R_translateY";
	rename -uid "D5CF9DE6-4071-8700-70D9-3F9F196AA819";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0.22994312368472952 9 0.93159531079510749
		 13 0 22 0.47476420443370554 26 0.22994312368472952;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "PoleLeg_R_translateZ";
	rename -uid "56325A39-42D7-3360-6533-4494A0A33D9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0.55939285165583008 9 0.56294000309019765
		 13 0 22 0.2152985180596565 26 0.55939285165583008;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RootX_M_translateX";
	rename -uid "AAAEDB0D-4EDC-5991-00B6-ED94EB6246D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 -1.166162822648515 7 -1.166162822648515
		 9 -0.3061792213269392 13 1.2690677154180725 20 1.2690677154180725 22 0.41603568469532481
		 26 -1.166162822648515;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RootX_M_translateY";
	rename -uid "2459DC7D-45D5-E480-B46D-82A4EA03FEE9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 -4.9646496743455826 7 -4.9646496743455826
		 9 -11.745600296183213 13 -4.9646496743455826 20 -4.9646496743455826 22 -11.622953860399317
		 26 -4.9646496743455826;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "RootX_M_translateZ";
	rename -uid "CADD8D3E-4A26-9306-F1BC-46982D894E27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 1.3535491714926104 7 1.3535491714926104
		 9 0.71783875753236881 13 1.7054854350161301 20 1.7054854350161301 22 1.7054854350161301
		 26 1.3535491714926104;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateX";
	rename -uid "56D0B6B8-4A0B-D765-EB77-E29FDDB6A22E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateY";
	rename -uid "037FAF0E-4C59-19F7-9A2F-298E3272CBBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateZ";
	rename -uid "A07136E7-4F89-FA17-3209-BE8CA517DAF5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKSpine1_M_rotateX";
	rename -uid "F7A39A30-44C2-2459-3B2A-52BDDB7ED8B8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 1.2261733629159026 0 1.4532425041966253
		 7 1.4532425041966253 9 0 13 8.2575919052733937 20 8.2575919052733937 22 0 26 1.4532425041966253;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKSpine1_M_rotateY";
	rename -uid "8F7C807B-4F1C-0B39-7DDE-E59099E560ED";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 -11.680908589012994 0 -12.833522238490522
		 7 -12.833522238490522 9 0 13 14.4504521706811 20 14.4504521706811 22 0 26 -12.833522238490522;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKSpine1_M_rotateZ";
	rename -uid "9B6B7B02-4C22-9855-29C5-55842B65388A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 -19.268785291520061 0 -25.566005293859391
		 7 -25.566005293859391 9 14.736202721112454 13 -18.965195090866509 20 -18.965195090866509
		 22 14.736202721112454 26 -25.566005293859391;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_L_rotateX";
	rename -uid "B7698E1C-4C9F-E5B6-9E03-F1B00B73DE79";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 6 0 9 4.4253378976109845 13 0 20 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_L_rotateY";
	rename -uid "9E8383DA-4595-8640-02C1-5FA37C7B134B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 6 0 9 -11.251026845552241 13 0 20 0
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_L_rotateZ";
	rename -uid "A0D6A7B3-42E2-99B8-0684-6297F7A884C2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 21.199924359625669 6 21.199924359625669
		 9 21.636036859123866 13 21.199924359625669 20 21.199924359625669 26 21.199924359625669;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKToes_L_rotateX";
	rename -uid "0040A83B-438B-0E05-C22D-69BBCD324E07";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKToes_L_rotateY";
	rename -uid "09996671-4799-EE84-24AD-ABB5A2177D8B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKToes_L_rotateZ";
	rename -uid "562EBCA6-413E-400E-A02B-1E8E6AC557EA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Gorro_Ctrl_rotateX";
	rename -uid "88D9B3C4-4829-76AF-DE9F-03847474FB12";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Gorro_Ctrl_rotateY";
	rename -uid "6DC0F507-4E2C-0793-B2F3-079A91F97F4D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Gorro_Ctrl_rotateZ";
	rename -uid "CBA800D6-45CC-46FD-4172-CCB75F16AD5C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "HipSwinger_M_rotateX";
	rename -uid "7DFD1ACF-4591-E6E2-85CB-02908A9CF359";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 9.7156273386123662 6 9.7156273386123662
		 13 0 19 0 26 9.7156273386123662;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "HipSwinger_M_rotateY";
	rename -uid "7D3D2980-40D4-F478-8039-D58333BA50CC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 -5.6308730627270247 6 -5.6308730627270247
		 13 0 19 0 26 -5.6308730627270247;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "HipSwinger_M_rotateZ";
	rename -uid "F01C6DA8-414D-5C4E-7AF8-7AB2B6DCE701";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 -28.647572954961237 6 -28.647572954961237
		 13 0 19 0 26 -28.647572954961237;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "HipSwinger_M_stabilize";
	rename -uid "57E87380-4B24-BCCD-6345-2AA8E4C4B22E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 10 6 10 13 10 19 10 26 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotateX";
	rename -uid "C77F0333-4463-6911-6B42-F888BE69D38C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -7.5885355288065668 7 -7.5885355288065668
		 13 0 19 0 22 5.5662357761355539 26 -7.5885355288065668;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotateY";
	rename -uid "AAE86027-4894-F50B-AC6F-75BBB689438F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -14.123727553195968 7 -14.123727553195968
		 13 0 19 0 22 -16.053975765569881 26 -14.123727553195968;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotateZ";
	rename -uid "343C9978-4107-092A-E7E8-94931B75A954";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 20.326508360357032 7 20.326508360357032
		 13 18.627309155407325 19 18.627309155407325 22 19.412872033401431 26 20.326508360357032;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateX";
	rename -uid "EA4A761C-404F-F95F-1C94-2098BC54C3EA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateY";
	rename -uid "820A7071-48DB-86A1-395E-7EBF930E9234";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateZ";
	rename -uid "C7664E1B-4DDF-9297-AAF1-A2BC61A37418";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "IKLeg_R_rotateX";
	rename -uid "28D54B65-40EB-1624-7B2A-BBBD1111BED5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 0 9 0 10 53.287134852355379 11 157.46257681609649
		 13 117.43268228454401 19 104.68449683393209 20 90.370070098950933 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "IKLeg_R_rotateY";
	rename -uid "7B50F21B-4F2D-9CB6-D830-D2AB45F03A6F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 6.2432369458441972 9 6.2432369458441972
		 10 21.651309163440192 11 21.716290852971564 13 27.833907433349879 19 27.833907433349879
		 20 16.584845647821915 22 6.2432369458441972 26 6.2432369458441972;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "IKLeg_R_rotateZ";
	rename -uid "95A0CA57-4ABF-BF9A-F36C-B5B350E2CB19";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 0 9 0 10 -11.656548204593509 11 -6.6705500798088764
		 13 -3.0272160089196598 19 -3.0272160089196598 20 -0.64012859414461121 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_toe";
	rename -uid "C0EE6B97-4F63-71DA-5505-8BA531804613";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 9 0 11 0 13 0 19 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_roll";
	rename -uid "E0318526-4BE3-3476-0E4B-508F7282F14B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 9 0 11 0 13 0 19 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_rollAngle";
	rename -uid "E9E39860-4D45-77C3-D4EF-F19EF1166034";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 25 9 25 11 25 13 25 19 25 22 25 26 25;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_stretchy";
	rename -uid "2545C5A2-4412-6723-0C1D-5586DEAA1ED7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 9 0 11 0 13 0 19 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_antiPop";
	rename -uid "86B49964-4245-675F-B5FB-20BEFE2B1979";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 9 0 11 0 13 0 19 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_Lenght1";
	rename -uid "B1C1BC8E-4B99-0D30-E7F7-A9ACF8F9D478";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 1 9 1 11 1.421875 13 1.5 19 1.5 22 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_Lenght2";
	rename -uid "38BE1159-41C9-6C33-440C-779DD0C350BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 1 9 1 11 1.421875 13 1.5 19 1.5 22 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_R_volume";
	rename -uid "002985F1-4545-1C24-BF84-0EBE01AA3149";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 10 9 10 11 10 13 10 19 10 22 10 26 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateX";
	rename -uid "FA279CD5-44A8-9893-18E6-718B3936C999";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateY";
	rename -uid "28E6B97A-41EC-BECA-94D7-4FBF9E923C1B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateZ";
	rename -uid "4013872C-4039-246D-7C2A-90B6BC7C3B42";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Fingers_L_indexCurl";
	rename -uid "0AFEBFE7-4DB1-BD35-5F6E-E59BEAB316C7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -2;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Fingers_L_middleCurl";
	rename -uid "07E050FD-4A19-E1B7-8B25-DFAE6A2943E3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1.2000000476837158;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Fingers_L_pinkyCurl";
	rename -uid "171AF84C-4D66-A7F6-3B27-FFB03013266A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 2;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Fingers_L_thumbCurl";
	rename -uid "0C706CA2-4467-F294-16E0-54BFB5C8A3AE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 2.5;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Fingers_L_spread";
	rename -uid "AB5E5A32-481C-91A4-AAD3-938C433ADBD7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0.10000000149011612;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_R_visibility";
	rename -uid "2AFB1168-4B19-288A-544B-35A068619887";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToesEnd_R_rotateX";
	rename -uid "206A06C2-429B-F804-AD48-7C9AF5979692";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToesEnd_R_rotateY";
	rename -uid "2EAB6736-4D2B-81F3-5201-1CB3E83D27E9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToesEnd_R_rotateZ";
	rename -uid "E9FB226A-4A57-0DD0-FD36-D78061BB6B5C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_R_scaleX";
	rename -uid "4F8A3648-4669-EE61-C68D-65AD6E7DBB4E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_R_scaleY";
	rename -uid "380EB185-4C3A-E498-0C88-CDB3CC1505E7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_R_scaleZ";
	rename -uid "70821A66-4C41-BC9F-E22F-BDBE974EB3B2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "IKLeg_L_rotateX";
	rename -uid "3A1C07F3-4832-A1E2-634D-B1A159A75E20";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 123.59792182903404 6 122.47855962809125
		 7 74.628918188901054 9 0 13 0 22 0 23 38.713889232407034 24 144.08304040047531 26 123.59792182903404;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "IKLeg_L_rotateY";
	rename -uid "2FEE4B10-4409-C5A1-6F33-43873369A3BA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 -11.703404705372243 6 -11.703404705372243
		 7 -6.4457803177079596 9 -3.3133110497915061 13 -3.3133110497915061 22 -3.3133110497915061
		 23 -11.220158175217261 24 -18.253972203686828 26 -11.703404705372247;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "IKLeg_L_rotateZ";
	rename -uid "8398B7D3-40D3-065D-BA1D-CA8CF46EEC57";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 4.036209741377653 6 4.036209741377653
		 7 0.58338345739125186 9 0 13 0 22 0 23 8.2427887595414546 24 0.47038302954415873
		 26 4.0362097413776503;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_toe";
	rename -uid "4F502A75-4B4C-34F2-DEB6-6FB4E981031F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 6 0 9 0 13 0 22 0 24 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_roll";
	rename -uid "CA453021-439E-050D-21A2-63B371F9D358";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 6 0 9 0 13 0 22 0 24 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_rollAngle";
	rename -uid "DE95F091-4058-E33C-F4B0-40A302FD4A0A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 25 6 25 9 25 13 25 22 25 24 25 26 25;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_stretchy";
	rename -uid "4DF670E8-494A-E00B-F4C3-C8B32FB39935";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 6 0 9 0 13 0 22 0 24 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_antiPop";
	rename -uid "F0F4A341-4D5D-9C86-440B-C1A9D0597AAC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 6 0 9 0 13 0 22 0 24 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_Lenght1";
	rename -uid "B49B8FF4-4088-2797-0C20-2784C77E90EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 1.5 6 1.5 9 1 13 1 22 1 24 1.421875 26 1.5;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_Lenght2";
	rename -uid "625F985E-4701-33BF-18CA-299E4B73C597";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 1.5 6 1.5 9 1 13 1 22 1 24 1.421875 26 1.5;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "IKLeg_L_volume";
	rename -uid "AF9AEB34-42FA-DC5F-53EB-9DB1AB6BFBA4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 10 6 10 9 10 13 10 22 10 24 10 26 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKArm_R_FKIKBlend";
	rename -uid "29C7157D-47FD-1FB7-348A-73A421A5B1C5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKArm_R_FKVis";
	rename -uid "605725E2-41F6-5956-BEA5-569CFC5CFD8E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKArm_R_IKVis";
	rename -uid "DC318E0C-4E57-D793-EE35-D9A91EACCACA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKRoot_M_rotateX";
	rename -uid "C5354B0E-44A2-89AA-C652-52AE10780623";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 1.2261733629159026 0 1.4532425041966253
		 7 1.4532425041966253 9 0 13 8.2575919052733937 20 8.2575919052733937 22 0 26 1.4532425041966253;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKRoot_M_rotateY";
	rename -uid "E36C9036-4248-7ECE-95C8-B8B2681F3C83";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 -11.680908589012994 0 -12.833522238490522
		 7 -12.833522238490522 9 0 13 14.4504521706811 20 14.4504521706811 22 0 26 -12.833522238490522;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKRoot_M_rotateZ";
	rename -uid "92C481FA-46BC-BC8F-B58F-C4A5074469B7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 -19.268785291520061 0 -25.566005293859391
		 7 -25.566005293859391 9 14.736202721112454 13 -18.965195090866509 20 -18.965195090866509
		 22 14.736202721112454 26 -25.566005293859391;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateX";
	rename -uid "BA135397-41A9-352C-F488-27B207551A55";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateY";
	rename -uid "C5AAE331-47C2-9E1A-E90B-2FB484377CDB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateZ";
	rename -uid "878F1789-4452-E5E3-F16F-01AF91BD32BD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger1_R_rotateX";
	rename -uid "170BCD51-47DE-96E0-4E0E-66A626CD3331";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger1_R_rotateY";
	rename -uid "932F12A5-4374-C878-AC77-BD8650938339";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger1_R_rotateZ";
	rename -uid "764A60DF-4397-0468-26D4-F78BB86B6BCE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_L_visibility";
	rename -uid "18C9CCEA-4D57-1AFC-F70A-89B220B8D4F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToes_L_rotateX";
	rename -uid "142BCA16-4A69-F713-80D7-949300F6E060";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToes_L_rotateY";
	rename -uid "87981CDB-4FB1-F6BF-B32B-E6A3A959E816";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToes_L_rotateZ";
	rename -uid "284809EE-4A76-E93F-9A9C-AB8CA57B2311";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_L_scaleX";
	rename -uid "46EBF1FE-4701-8662-BB7B-739398A7A87E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_L_scaleY";
	rename -uid "57578D53-4AFB-9413-F4C4-9E9F44A7607C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_L_scaleZ";
	rename -uid "BAE1F5F2-4D34-B395-D2E9-AEBD094AE83B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateX";
	rename -uid "42301118-4D83-2F47-9322-D69CD7AEED8C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateY";
	rename -uid "8F52861A-4585-F183-CCBA-42AE5A54DE71";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateZ";
	rename -uid "2558194E-464E-CFC3-D9F3-72AEF8D61121";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKChest_M_rotateX";
	rename -uid "2FFAD1EC-4897-B3CA-5C94-4EA448E6962D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 1.2261733629159026 0 1.4532425041966253
		 7 1.4532425041966253 9 0 13 8.2575919052733937 20 8.2575919052733937 22 0 26 1.4532425041966253;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKChest_M_rotateY";
	rename -uid "8598D4B5-4F33-A527-B61A-9EA89C4ECBD0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 -11.680908589012994 0 -12.833522238490522
		 7 -12.833522238490522 9 0 13 14.4504521706811 20 14.4504521706811 22 0 26 -12.833522238490522;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKChest_M_rotateZ";
	rename -uid "75D4EE29-4489-4B26-AC33-93A2736D2428";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 8 ".ktv[0:7]"  -1 -19.268785291520061 0 -25.566005293859391
		 7 -25.566005293859391 9 14.736202721112454 13 -18.965195090866509 20 -18.965195090866509
		 22 14.736202721112454 26 -25.566005293859391;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_L_visibility";
	rename -uid "21C38A80-4E0C-2056-5D90-56A150A8D8AB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToesEnd_L_rotateX";
	rename -uid "51A8FB17-4B48-8810-D3B1-A7A32484400D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToesEnd_L_rotateY";
	rename -uid "2718DB0D-40D7-41D1-0361-A99E322A1238";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToesEnd_L_rotateZ";
	rename -uid "92F22BD0-4159-78AE-44BE-C18472256C29";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_L_scaleX";
	rename -uid "905934A2-47C6-D594-8C12-3DBF5FC9A3B1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_L_scaleY";
	rename -uid "75459EB9-4238-7F05-50B2-5E95DC5B4209";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToesEnd_L_scaleZ";
	rename -uid "3D432ECA-4A96-5A81-71BC-F286CCD5003D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger1_L_rotateX";
	rename -uid "BE1BB0E0-44DE-79E5-52FD-608492CFBEF1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger1_L_rotateY";
	rename -uid "E7613118-4EF2-5418-08BF-BBA389B510D0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger1_L_rotateZ";
	rename -uid "45CB631F-4256-770A-A448-FBA0647088FF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "PoleLeg_R_follow";
	rename -uid "416ED86E-4494-5F3B-096A-12AE535595DE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 10 9 10 13 10 22 10 26 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "PoleLeg_R_lock";
	rename -uid "E077F593-42DB-6281-D21C-8D91A47EEA69";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 9 0 13 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger2_R_rotateX";
	rename -uid "6F9162CC-4A4B-41C4-8C88-5099A4F49681";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger2_R_rotateY";
	rename -uid "7F187F00-477D-A5A6-16AC-CFBA1197245A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger2_R_rotateZ";
	rename -uid "968BDF6B-4BD5-0DB7-C6A2-14A9D2FBD0F0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateX";
	rename -uid "A007748E-4924-BB44-846B-D587E8F7C424";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateY";
	rename -uid "A32B2480-49D2-D842-EEF7-C5B5967BD288";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateZ";
	rename -uid "5964DC7E-45D9-71A6-9C82-00B5D6E5E1DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKArm_L_FKIKBlend";
	rename -uid "AB559A15-42BF-EA18-82DA-9DAF4B5EDA5F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKArm_L_FKVis";
	rename -uid "D4D6B1AD-42D2-C419-E03F-FB84F3124F16";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKArm_L_IKVis";
	rename -uid "23109CC4-4071-B772-52B2-ACA610A17907";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_L_rotateX";
	rename -uid "ED51A116-456A-E6E3-C47E-779F79F48A9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 6 0 13 0 20 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_L_rotateY";
	rename -uid "082B97DC-409E-E776-98F3-7FA260CA7CFC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 6 0 9 -14.284828513395652 13 0 20 0
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_L_rotateZ";
	rename -uid "B16A8412-4F36-A584-479A-3D875EE2599A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 28.383819882543715 6 28.383819882543715
		 13 28.383819882543715 20 28.383819882543715 26 28.383819882543715;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKLeg_R_FKIKBlend";
	rename -uid "9461EFCF-4C41-172C-1D20-838A4D47D1CE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 10 13 10 26 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKLeg_R_FKVis";
	rename -uid "5591AE13-4E32-ACBD-F3A6-F18DA5CFF108";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKLeg_R_IKVis";
	rename -uid "4D45E1C0-413F-4877-8DD1-9F8417AC2BBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger3_L_rotateX";
	rename -uid "A4ECFE52-450F-4BBA-275B-97947781A6EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger3_L_rotateY";
	rename -uid "7E0108CE-4CD1-F01E-55EC-BC88C2198D1E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger3_L_rotateZ";
	rename -uid "C5785BE7-4174-2467-C91A-E08445B57ECD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger1_L_rotateX";
	rename -uid "872AED8B-4045-D79D-1FCF-319C89BAE46A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger1_L_rotateY";
	rename -uid "8E80DEEC-45A9-7DAC-8211-BC89D40BA5A0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger1_L_rotateZ";
	rename -uid "7022AE5A-452A-6F90-0DD4-50B20FDEB75D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotateX";
	rename -uid "268BBC50-4BD2-BBC7-B0D2-578D5CDE959B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 7 0 13 0 19 0 22 2.6228067136732665
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotateY";
	rename -uid "41955FB4-41D5-A0B7-341D-568CC817A9B1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 7 0 13 0 19 0 22 -9.4875868990280772
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotateZ";
	rename -uid "AA699FB0-410A-B70E-4C98-F68F22093FEB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 15.313330745094524 7 15.313330745094524
		 13 15.313330745094524 19 15.313330745094524 22 15.531020856340628 26 15.313330745094524;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger2_R_rotateX";
	rename -uid "FFD4AEAC-47DF-BD33-960B-06911A0F5DBF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger2_R_rotateY";
	rename -uid "00A22B77-4F2B-191F-76D4-0AB0DC714AE5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger2_R_rotateZ";
	rename -uid "5850E18E-4831-7A1E-5358-669E7364B706";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateX";
	rename -uid "C6DEAC2F-4B74-0058-903C-8AABE9D286DE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateY";
	rename -uid "82509DEB-4FE6-B4B2-94A9-C7943A8BCDD5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateZ";
	rename -uid "5CE14367-47DD-33FB-D2F5-38AED51C0A2F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKHead_M_rotateX";
	rename -uid "437A2682-45C1-2669-E187-31A46DD582A9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 12.562641910649209 1 13.315022769214799
		 9 13.315022769214799 15 -5.2259247310191315 21 -5.2259247310191315 26 12.562641910649209;
	setAttr -s 6 ".kit[0:5]"  1 18 18 1 18 1;
	setAttr -s 6 ".kot[0:5]"  1 18 18 1 18 1;
	setAttr -s 6 ".kix[0:5]"  0.64381270612050923 1 1 1 1 0.64252644027216033;
	setAttr -s 6 ".kiy[0:5]"  0.76518311497169544 0 0 0 0 0.7662635144329828;
	setAttr -s 6 ".kox[0:5]"  0.64381271336458956 1 1 1 1 0.64252639951374224;
	setAttr -s 6 ".koy[0:5]"  0.7651831088766432 0 0 0 0 0.76626354860968482;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKHead_M_rotateY";
	rename -uid "FF3B33B7-42F0-6DDD-7F3B-DEB12FB93583";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 21.783028091582494 1 22.788243816487746
		 9 22.788243816487746 15 -7.8035010567286633 21 -7.8035010567286633 26 21.783028091582494;
	setAttr -s 6 ".kit[0:5]"  1 18 18 1 18 1;
	setAttr -s 6 ".kot[0:5]"  1 18 18 1 18 1;
	setAttr -s 6 ".kix[0:5]"  0.5145824898000656 1 1 1 1 0.51314916305537572;
	setAttr -s 6 ".kiy[0:5]"  0.8574408791229664 0 0 0 0 0.8582994445154718;
	setAttr -s 6 ".kox[0:5]"  0.51458252863734055 1 1 1 1 0.51314914129648992;
	setAttr -s 6 ".koy[0:5]"  0.85744085581525709 0 0 0 0 0.85829945752439751;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKHead_M_rotateZ";
	rename -uid "1B5B17F6-43A1-5F7F-4CDA-D3BEADEB9CE6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 -18.657337287362925 1 -27.665429398992121
		 9 -27.665429398992121 11 -11.617689932419356 15 -28.642629484506841 21 -28.21029517266328
		 26 -18.657337287362925;
	setAttr -s 7 ".kit[4:6]"  1 1 18;
	setAttr -s 7 ".kot[4:6]"  1 1 18;
	setAttr -s 7 ".kix[4:6]"  1 0.19999999999999996 1;
	setAttr -s 7 ".kiy[4:6]"  0 0.011737688994910678 0;
	setAttr -s 7 ".kox[4:6]"  1 0.2333333333333335 1;
	setAttr -s 7 ".koy[4:6]"  0 0.013693970494062624 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateX";
	rename -uid "B4B9F6DC-46FF-EEEC-698B-E7B8B9338A28";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateY";
	rename -uid "E46ACEA3-449B-D451-B93B-C384D05C01A4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateZ";
	rename -uid "22967410-45D6-CF5B-48FE-B0A87B7AECA4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_L_visibility";
	rename -uid "6728D453-4D47-1961-D02B-D68E38E1F16E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollHeel_L_rotateX";
	rename -uid "CAB4AB99-46F8-B921-4593-0D8337BDB54B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollHeel_L_rotateY";
	rename -uid "C31EF248-4FB7-B096-63FD-C0AF807F97E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollHeel_L_rotateZ";
	rename -uid "389B2C16-4F31-53C8-CC95-6D90F2EACC27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_L_scaleX";
	rename -uid "76F0250F-476D-6BC8-909B-02B8CA2B8C40";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_L_scaleY";
	rename -uid "347D8AC5-4049-8064-27BF-B0AB352837D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_L_scaleZ";
	rename -uid "E8B2CFE1-47EB-5407-8D8B-E59F53D4C20B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder_R_rotateX";
	rename -uid "28DC7A74-4FF1-F344-4497-FBB4E8D99205";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 7 0 13 9.4509478866891268 19 9.4509478866891268
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder_R_rotateY";
	rename -uid "CA5F9CE0-4783-F87E-0115-A9A801289C8B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 7 0 13 -17.378192893788423 19 -17.378192893788423
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder_R_rotateZ";
	rename -uid "2F7285D4-4DBD-0389-0671-57BC1A1AE55D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 7 0 13 27.498014222104427 19 27.498014222104427
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "pairBlend1_inRotateX1";
	rename -uid "B621FDA5-4D73-4D48-C8BC-6DA41DB751C1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 60.728925002333661 13 60.728925002333661
		 26 60.728925002333661;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "pairBlend1_inRotateY1";
	rename -uid "5879C400-40A0-6383-8015-258148332D1B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 -5.128391783724406 13 -5.128391783724406
		 26 -5.128391783724406;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "pairBlend1_inRotateZ1";
	rename -uid "D2291108-455F-A005-9D32-C1B968ABAAB0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 -23.567606618096431 13 -23.567606618096431
		 26 -23.567606618096431;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Collar_Ctrl_Master_blendParent1";
	rename -uid "05389923-4068-B86E-5876-28B16677D257";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger3_R_rotateX";
	rename -uid "33CE1136-4DAD-D836-739C-9A90CD27F040";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger3_R_rotateY";
	rename -uid "1AC20F34-41FE-523D-51BB-1AA7D6E6DC7A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger3_R_rotateZ";
	rename -uid "F44A6287-4F11-4A3D-580B-BB8FAB118388";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder_L_rotateX";
	rename -uid "8813B195-40CA-1C83-693F-BA9BC669B0ED";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 5.4810541991890602 6 5.4810541991890602
		 10 21.804160516216797 13 -13.480249970002445 20 -13.480249970002445 26 5.793818168894135;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder_L_rotateY";
	rename -uid "87CD65D8-45A0-3EAA-2A6A-759518C2B9EA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -28.582551868789455 6 -28.582551868789455
		 10 13.433338135880669 13 -12.272965964760226 20 -12.272965964760226 26 -14.40411750861306;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder_L_rotateZ";
	rename -uid "CE040515-4BD8-FB0D-A423-3FA16381E379";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -1.2365855157636976 6 -1.2365855157636976
		 10 3.2128628897766593 13 -25.32385636503443 20 -25.32385636503443 26 -1.1211079397299721;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_R_visibility";
	rename -uid "08F4F551-46C7-47E9-F443-E8AD3AD1F6FA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollHeel_R_rotateX";
	rename -uid "E60AC166-43B6-D999-15FF-11BA7DF893AE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollHeel_R_rotateY";
	rename -uid "940CD057-4F89-112D-7739-61A6BB06A63C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollHeel_R_rotateZ";
	rename -uid "4952C05D-4A10-09FA-0246-F8AAFEC59C66";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_R_scaleX";
	rename -uid "39DBC4A7-4658-1AEA-52F3-6E99CC86BD26";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_R_scaleY";
	rename -uid "6B857B9C-4D34-2678-E531-44895B23235D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_R_scaleZ";
	rename -uid "54B294F9-4752-7A73-BFAB-2CB512E35984";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger2_L_rotateX";
	rename -uid "A35F87F1-4797-8497-7976-08831373CDB4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger2_L_rotateY";
	rename -uid "FEF6AB30-43B5-C221-26C0-3388E4C6A4DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger2_L_rotateZ";
	rename -uid "5B415852-4289-3483-AD29-84AEDCE7472B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateX";
	rename -uid "93CE4995-4A09-6A35-88E6-0C8EFE39C6C1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateY";
	rename -uid "C83C9BCB-49B6-73D5-4E0A-F4B5B56368D9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateZ";
	rename -uid "20416252-4D3C-558F-647A-5997AEE8C136";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger1_R_rotateX";
	rename -uid "8619FC34-4D20-132D-E5F8-A6B345596ED1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger1_R_rotateY";
	rename -uid "FCB2862E-4DCF-E9C4-BD9F-F2BD2356D091";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKThumbFinger1_R_rotateZ";
	rename -uid "61502B18-4449-A4B7-E8A4-ED8CC9293E04";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKSpine_M_FKVis";
	rename -uid "1848E30B-453D-5D55-AF6F-798261142F9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKSpine_M_IKVis";
	rename -uid "65B4658A-4549-679D-B015-ED86351FBD3E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Main_visibility";
	rename -uid "946BD396-4B7B-A30A-5679-A9B955AD8088";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Main_rotateX";
	rename -uid "4AF64498-40D9-02E7-429F-E69A491F35B1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Main_rotateY";
	rename -uid "BB760BF9-44BF-05CA-A075-9D96A29F3BF8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Main_rotateZ";
	rename -uid "4395AC8A-45B3-9685-629A-7FAD1FF37344";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Main_scaleX";
	rename -uid "885EF2A8-4D62-D0F2-4993-42A53AD24C7B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Main_scaleY";
	rename -uid "DB1961DF-4F17-0A05-9073-AF9FA7ADD8ED";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Main_scaleZ";
	rename -uid "4AF9E132-48BD-8367-6A27-DF8B4A639AFF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_R_rotateX";
	rename -uid "C9FC0537-499F-BB8D-AA13-66A7BAB12A01";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -92.892935092182952 7 -92.892935092182952
		 13 44.315304589600643 19 44.315304589600643 22 86.307149734119363 26 -92.892935092182952;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_R_rotateY";
	rename -uid "46A7F45B-48C9-9E75-D1F2-5A976495F3F4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -6.0571066442513439 7 -6.0571066442513439
		 13 -2.7831737043307858 19 -2.7831737043307858 22 26.933912176000373 26 -6.0571066442513439;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_R_rotateZ";
	rename -uid "AC05BF90-494F-3C44-DBBC-5A82C6C4D46B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -51.865139582991702 7 -51.865139582991702
		 13 10.642015868541939 19 10.642015868541939 22 42.349399110831129 26 -51.865139582991702;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote01_Ctrl_visibility";
	rename -uid "20C912B3-4FAD-77F5-FF99-109EFCE05BA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Bigote01_Ctrl_rotateX";
	rename -uid "C6481F90-4A04-5050-271E-D2A5AC954604";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Bigote01_Ctrl_rotateY";
	rename -uid "8EF95732-415C-A974-EB97-A790DA3302C0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Bigote01_Ctrl_rotateZ";
	rename -uid "B1348D4D-44BE-7C99-5A1E-7398358C1201";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote01_Ctrl_scaleX";
	rename -uid "31C6F8B9-4F19-FE95-402A-15B0F1335E3B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote01_Ctrl_scaleY";
	rename -uid "F0967F4E-49F9-29CD-1AA3-D7B985D9CD7E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote01_Ctrl_scaleZ";
	rename -uid "1255FCA8-45F1-6D9E-3CCF-AEB78400A8EA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger2_L_rotateX";
	rename -uid "89783925-4260-69BA-CA10-068B38D502EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger2_L_rotateY";
	rename -uid "7B5E43FD-403D-DE47-0554-B0AB5EFCEB8F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger2_L_rotateZ";
	rename -uid "6DAA0DAB-47A7-9073-4B29-6EA6FC3B6385";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateX";
	rename -uid "E2C88FFC-4682-F3A8-771D-18A464358359";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateY";
	rename -uid "22143DC7-4D69-05AD-568F-59AFC92A0FE4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateZ";
	rename -uid "43C703FE-4823-36AF-E5A2-E0AE3731C61E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKLeg_L_FKIKBlend";
	rename -uid "2CB3A10A-4222-CCDB-6209-1CAAD6E6B26B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 10 13 10 26 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKLeg_L_FKVis";
	rename -uid "D0A528CE-4267-530A-F0DA-24A057AA7163";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "FKIKLeg_L_IKVis";
	rename -uid "4CACBAAA-48DD-C654-9207-F0BE9B547373";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateX";
	rename -uid "B49E61BD-4842-3464-8F9F-5282DB1DF421";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateY";
	rename -uid "1B93A7FD-4982-E7E7-A0E8-0DA06E24A2CE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateZ";
	rename -uid "C028F536-4E90-75A7-BACD-06A74DE79D8F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "PoleLeg_L_follow";
	rename -uid "234ED012-4BB8-CCC0-865D-D79CE2307A4A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 10 6 10 13 10 22 10 26 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "PoleLeg_L_lock";
	rename -uid "057C770F-4C34-3162-AF2B-D6AB4FF82E28";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 6 0 13 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateX";
	rename -uid "65D4FFFE-4E4F-0BD4-FBA1-56AE32D19402";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateY";
	rename -uid "FCAC4884-4482-5087-8DE1-AB86959116F5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateZ";
	rename -uid "0B8B005B-4E84-A97B-7D1A-6F849892CA21";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_L_rotateX";
	rename -uid "2772D0E8-4D01-19F9-D0BB-91B469D4C7E7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 11 ".ktv[0:10]"  0 50.436325136592984 6 50.436325136592984
		 8 87.219759691539196 9 97.765462894500601 10 59.774721098876434 11 235.6594690920823
		 12 243.8862984582633 13 -79.488411310543455 20 -79.488411310543455 22 47.198432531230971
		 26 50.436325136592984;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_L_rotateY";
	rename -uid "5AA511E3-443A-04AF-C11C-A68A5485A571";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 11 ".ktv[0:10]"  0 -18.656459751766917 6 -18.656459751766917
		 8 21.098737560387651 9 29.303124739104486 10 66.292002089839755 11 73.326864060262722
		 12 54.310817127170161 13 43.387826068656317 20 43.387826068656317 22 53.068852175508439
		 26 -18.656459751766917;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_L_rotateZ";
	rename -uid "27DF32EA-4167-135B-D133-E8919D5E5950";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 11 ".ktv[0:10]"  0 34.46714757516088 6 34.46714757516088
		 8 86.909344049870029 9 101.57516207240951 10 74.562204086028061 11 257.15335176809305
		 12 272.9395515572669 13 -52.129473409945412 20 -52.129473409945412 22 77.092997014676186
		 26 34.46714757516088;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_R_visibility";
	rename -uid "09911EEF-4367-2C26-EF76-FC90007F144C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToes_R_rotateX";
	rename -uid "ADE22B33-43F9-38D4-5DA4-E68872C8D2B9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToes_R_rotateY";
	rename -uid "8C24B7A8-48D3-4A6B-0020-42BB4722BD9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RollToes_R_rotateZ";
	rename -uid "AEE61607-4F99-2D04-8979-B58339BD6E9D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_R_scaleX";
	rename -uid "2AC930BC-4CFB-B2B0-D3B3-DD90FC8E0F4A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_R_scaleY";
	rename -uid "A0F55F2F-4AF3-C121-093E-9D8DF878EB58";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollToes_R_scaleZ";
	rename -uid "2B4EEF59-47DE-F264-3918-8C81B4841A4D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKToes_R_rotateX";
	rename -uid "D856BFE6-4F2D-FA38-671F-25BA87145C2B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKToes_R_rotateY";
	rename -uid "FC556DA5-4468-F221-2098-7ABCF37C9811";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKToes_R_rotateZ";
	rename -uid "C13DE86C-4151-4103-04A6-1A92C045E4EA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger3_R_rotateX";
	rename -uid "23102FF0-4011-E781-E2DB-F6895CADB976";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger3_R_rotateY";
	rename -uid "B27B4E25-4B4B-8203-219D-0A9E7AE49A4F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger3_R_rotateZ";
	rename -uid "096AE07D-420E-CCCB-20F6-FE806A36C753";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger3_L_rotateX";
	rename -uid "4289644E-4F16-F50B-7EC6-CC8902BC0C71";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger3_L_rotateY";
	rename -uid "D4F65E5F-43B0-BB47-2A7B-A989A55BE744";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger3_L_rotateZ";
	rename -uid "9176EDB0-43F5-C15B-F808-188BBFAA7248";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote02_Ctrl_visibility";
	rename -uid "ED0A764F-4EC0-6DEB-8DDC-C7ADB49A5478";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Bigote02_Ctrl_rotateX";
	rename -uid "E7D26996-4DB3-1BC5-12A1-4480B3960223";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Bigote02_Ctrl_rotateY";
	rename -uid "C0381A51-4B48-FF71-392F-0FB1F765A6E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Bigote02_Ctrl_rotateZ";
	rename -uid "E639876B-4184-D39B-C374-DF8AF9A2B2BF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 0 13 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote02_Ctrl_scaleX";
	rename -uid "C4080B0A-4698-5955-20EA-18A15F468DA6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote02_Ctrl_scaleY";
	rename -uid "7AA061A0-41D0-2218-AE72-D89B77704BBA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "Bigote02_Ctrl_scaleZ";
	rename -uid "F764FCF8-43FC-1648-D771-BA8D7707F06E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1 13 1 26 1;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_L_rotateX";
	rename -uid "ED1CFC43-4AA3-7B6A-205C-7D8710826F33";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 6 0 9 9.3644088923872619 13 0 20 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_L_rotateY";
	rename -uid "8CBDC786-4113-B47D-301B-FAA15A900D91";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 6 0 9 -19.659941070625202 13 0 20 0
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_L_rotateZ";
	rename -uid "E028A6E8-400C-E1E7-A878-9C83AC476445";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 24.486566489636292 6 24.486566489636292
		 9 26.112638165466837 13 24.486566489636292 20 24.486566489636292 26 24.486566489636292;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotateX";
	rename -uid "41808278-4475-41D5-5D33-1CB2175AFBC1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 0 7 0 13 0 19 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotateY";
	rename -uid "7203D403-4CAA-C661-3D45-4C9FC87659DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 7 0 13 0 19 0 22 -11.600890215061314
		 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotateZ";
	rename -uid "AE949FCE-4F35-1EFB-4412-3E966BFDB317";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 5 ".ktv[0:4]"  0 24.363436449416874 7 24.363436449416874
		 13 24.363436449416874 19 24.363436449416874 26 24.363436449416874;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RootX_M_rotateX";
	rename -uid "ACCFBA95-46CF-01FF-B8A0-D99BA7132F8D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 79.38927011283424 7 79.38927011283424
		 9 19.230084093337425 13 73.074944657820041 20 73.074944657820041 22 19.594883835841429
		 26 79.38927011283424;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RootX_M_rotateY";
	rename -uid "204AAFB1-4BD2-E0BB-DDD1-2080B35B806F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 -35.47448642519938 7 -35.47448642519938
		 9 0 13 13.597428871563828 20 13.597428871563828 22 0 26 -35.47448642519938;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RootX_M_rotateZ";
	rename -uid "38838564-49B7-7A96-4DAC-74B9C4B6823F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 -1.4685205507279568 7 -1.4685205507279568
		 9 0 13 -30.401818821508254 20 -30.401818821508254 22 0 26 -1.4685205507279568;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RootX_M_legLock";
	rename -uid "438D5ACF-41B3-0D62-4AEE-CF92D6886EEB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 7 0 9 0 13 0 20 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RootX_M_CenterBtwFeet";
	rename -uid "1304C778-462C-89D3-4A67-D1BD8B5366FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 7 0 9 0 13 0 20 0 22 0 26 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode polyDisc -n "polyDisc1";
	rename -uid "3E513E2A-4B25-59C7-1760-AEA146525781";
createNode lambert -n "lambert2";
	rename -uid "82D6F25C-4C19-EF18-5D51-A5B528893667";
createNode shadingEngine -n "lambert2SG";
	rename -uid "247E9373-42F2-7C4D-5AF7-1494392CF4F8";
	setAttr ".ihi" 0;
	setAttr ".ro" yes;
createNode materialInfo -n "materialInfo1";
	rename -uid "E44ABF39-48C8-0DBE-046A-1682DF5114AD";
createNode projection -n "projection1";
	rename -uid "C8A2E0F2-4738-0FF0-DBD6-9A8450C098D1";
	setAttr ".vt1" -type "float2" 0.5 0.38461539 ;
	setAttr ".vt2" -type "float2" 0.5 0.38461539 ;
	setAttr ".vt3" -type "float2" 0.5 0.38461539 ;
createNode checker -n "checker1";
	rename -uid "3381440E-487B-3581-19AA-AD9ABC5F5C09";
	setAttr ".c1" -type "float3" 0.37209302 0.37209302 0.37209302 ;
	setAttr ".c2" -type "float3" 0.24418604 0.24418604 0.24418604 ;
createNode place2dTexture -n "place2dTexture1";
	rename -uid "ADA82524-4BB6-CCD0-C9A2-7BB3B3726A31";
	setAttr ".re" -type "float2" 4 4 ;
createNode animCurveTL -n "place3dTexture1_translateX";
	rename -uid "E970E9D1-434D-75F1-DBE4-FD81312F1667";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 26 0;
createNode animCurveTL -n "place3dTexture1_translateY";
	rename -uid "672EA1EC-413D-2B0C-BEF3-6EB6C216E51E";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 26 0;
createNode animCurveTL -n "place3dTexture1_translateZ";
	rename -uid "F7E0680B-45EE-B0D2-238A-6CBFD894FA46";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 26 -200;
createNode animCurveTU -n "place3dTexture1_visibility";
	rename -uid "E6AAFFD1-45EC-6992-8E07-0984236A2031";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 1 26 1;
createNode animCurveTA -n "place3dTexture1_rotateX";
	rename -uid "A5FA9B27-4092-CCDA-BA93-6E8A373EEDB3";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 -90.000000000000028 26 -90.000000000000028;
createNode animCurveTA -n "place3dTexture1_rotateY";
	rename -uid "9F00F60F-451A-A881-5152-A8846608D15D";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 26 0;
createNode animCurveTA -n "place3dTexture1_rotateZ";
	rename -uid "BAA23DAD-4EB4-F5BB-6FC3-4783FEA6A3B8";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 26 0;
createNode animCurveTU -n "place3dTexture1_scaleX";
	rename -uid "CF63F527-438E-CF31-DE22-ADB603152817";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 100 26 100;
createNode animCurveTU -n "place3dTexture1_scaleY";
	rename -uid "6429C151-4364-C104-0EA4-DDB5621F5BDC";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 100 26 100;
createNode animCurveTU -n "place3dTexture1_scaleZ";
	rename -uid "3A2DC8D1-4B75-A45C-C8E7-5DB97BA20A34";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 100 26 100;
createNode animCurveTL -n "FKRootPart1_M_translateX";
	rename -uid "07FB1CE5-4F70-7AA3-5A03-1288A80CC614";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKRootPart1_M_translateY";
	rename -uid "2C4B8E2F-4F56-78B5-D0D0-B89B0246578E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKRootPart1_M_translateZ";
	rename -uid "3B3A8EC8-4CF1-29B8-19DA-A0A6857AC457";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKRootPart1_M_rotateX";
	rename -uid "ED5952DC-4615-2593-88EA-6CB9A8616A37";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKRootPart1_M_rotateY";
	rename -uid "97D664F1-4FC0-578C-C7F7-70A2E1581545";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKRootPart1_M_rotateZ";
	rename -uid "2ADA096A-4193-3C36-DCCB-01B885008017";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKRootPart2_M_translateX";
	rename -uid "9E2B24E8-4BA3-5C2E-F6C4-A685C8106CA2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKRootPart2_M_translateY";
	rename -uid "9EFA492C-4A71-B34C-CBBF-AF911B8A7F85";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKRootPart2_M_translateZ";
	rename -uid "98FDA534-4591-F109-BBDC-EDBE9886AC42";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKRootPart2_M_rotateX";
	rename -uid "F9ACD7E6-49D6-FD39-6046-C98D94004064";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKRootPart2_M_rotateY";
	rename -uid "9CC808FA-485A-25AA-B0F3-47A42AB0CF0B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKRootPart2_M_rotateZ";
	rename -uid "0A587A56-432B-EE44-9535-E096800557A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKSpine1Part1_M_translateX";
	rename -uid "EBD9CA13-4A1F-7B14-4B95-3D88DC587E0A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKSpine1Part1_M_translateY";
	rename -uid "18D4E7BA-4B0C-2EF4-50BF-57BA34048A2F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKSpine1Part1_M_translateZ";
	rename -uid "79F95388-4174-C077-2AB6-3784E105E644";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKSpine1Part1_M_rotateX";
	rename -uid "8F1E0346-4E40-D263-4177-CCB23F203E85";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKSpine1Part1_M_rotateY";
	rename -uid "A5AAADD2-4F4D-79E3-8F3C-D8ABCE82EF14";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKSpine1Part1_M_rotateZ";
	rename -uid "6749E338-4A71-3A92-AAC5-3BA3274B681E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKSpine1Part2_M_translateX";
	rename -uid "CD4CF340-4D4F-7800-F9BB-8089D9832890";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKSpine1Part2_M_translateY";
	rename -uid "43050CA2-43AE-F13F-7859-A9859267363A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKSpine1Part2_M_translateZ";
	rename -uid "314BCFAE-476A-668E-66CF-B38E9AB01E3C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKSpine1Part2_M_rotateX";
	rename -uid "7DC01E68-4B6A-DC14-8506-78949988AE3F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKSpine1Part2_M_rotateY";
	rename -uid "866756C0-4890-27B8-DC61-238200E9C230";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "FKSpine1Part2_M_rotateZ";
	rename -uid "398834C2-4C69-16CF-5B78-C59EF7B9BD39";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "IKSpine1_M_translateX";
	rename -uid "3A0B6610-4F8D-79F4-EFCE-BFA0DC1B2DF9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "IKSpine1_M_translateY";
	rename -uid "BF538E42-4C8E-99C6-EC03-638418BFAA08";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "IKSpine1_M_translateZ";
	rename -uid "AC726774-45B0-6AD2-3183-90B82E4F190A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "IKSpine1_M_rotateX";
	rename -uid "7EC1D467-4E9F-7C2D-2663-EE895403A9EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "IKSpine1_M_rotateY";
	rename -uid "364ABA1C-426D-2A93-3ECC-BE876DBB1F70";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "IKSpine1_M_rotateZ";
	rename -uid "5B639F7E-48EE-1385-3A9B-C2A7E95A7C83";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "IKSpine2_M_translateX";
	rename -uid "509A0E34-4FBA-50DC-5B8E-2F8E51EEF463";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "IKSpine2_M_translateY";
	rename -uid "04291A81-4E40-9A99-3A06-8E981DAA5C6B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "IKSpine2_M_translateZ";
	rename -uid "1E96A5B6-4E2A-0B44-6C78-698727AED5C7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "IKSpine2_M_rotateX";
	rename -uid "FAAE56E6-40AA-7AFF-2FD5-14A3069A77E7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "IKSpine2_M_rotateY";
	rename -uid "37AF6731-4FD6-66DA-1401-7A82E266967C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTA -n "IKSpine2_M_rotateZ";
	rename -uid "9D8E39C4-4E68-F581-3BBC-CA9EBFE34E25";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  -1 0;
createNode animCurveTL -n "FKSpine1_M_translateX";
	rename -uid "527D5092-47E9-D786-DF45-21BFDEA99014";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 0 7 0 8 1.2025399751300583 10 -1.8636118951674696
		 13 0 20 0 21 1.2171261875698276 23 -1.9238446190619847 26 0;
	setAttr -s 9 ".kit[5:8]"  1 1 1 18;
	setAttr -s 9 ".kot[5:8]"  1 1 1 18;
	setAttr -s 9 ".kix[5:8]"  1 0.033333333333333215 1 1;
	setAttr -s 9 ".kiy[5:8]"  0 0 0 0;
	setAttr -s 9 ".kox[5:8]"  1 0.033333333333333215 1 1;
	setAttr -s 9 ".koy[5:8]"  0 0 0 0;
createNode animCurveTL -n "FKSpine1_M_translateY";
	rename -uid "4DA044E3-4E43-9333-B8AC-42A5D2AA936E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 7 0 9 0 13 0 20 0 22 0 26 0;
createNode animCurveTL -n "FKSpine1_M_translateZ";
	rename -uid "5004B78A-4621-D777-E287-24A83D320BE9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 7 0 9 0 13 0 20 0 22 0 26 0;
createNode animCurveTL -n "FKChest_M_translateX";
	rename -uid "6A17D804-4F16-3A34-5559-6CBCB0E061EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 9 ".ktv[0:8]"  0 0 7 0 8 1.2025399751300583 10 -1.8636118951674696
		 13 0 20 0 21 1.2171261875698276 23 -1.9238446190619847 26 0;
	setAttr -s 9 ".kit[5:8]"  1 1 1 18;
	setAttr -s 9 ".kot[5:8]"  1 1 1 18;
	setAttr -s 9 ".kix[5:8]"  1 0.033333333333333215 1 1;
	setAttr -s 9 ".kiy[5:8]"  0 0 0 0;
	setAttr -s 9 ".kox[5:8]"  1 0.033333333333333215 1 1;
	setAttr -s 9 ".koy[5:8]"  0 0 0 0;
createNode animCurveTL -n "FKChest_M_translateY";
	rename -uid "CC995CF0-44D6-765C-EAD6-57AF20E03E7B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 7 0 9 0 13 0 20 0 22 0 26 0;
createNode animCurveTL -n "FKChest_M_translateZ";
	rename -uid "9EBBAAD2-4DE2-7A02-E88C-CE9390936993";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 7 ".ktv[0:6]"  0 0 7 0 9 0 13 0 20 0 22 0 26 0;
createNode animLayer -n "BaseAnimation";
	rename -uid "AE88E4F9-4FD6-C183-C758-409D6EBA2D4A";
	setAttr -s 2 ".cdly";
	setAttr -s 2 ".chsl";
	setAttr ".ovrd" yes;
createNode animLayer -n "BakeResults";
	rename -uid "67621C92-4C07-C4D0-FB7A-F8A6A9B1DFED";
	setAttr -s 15 ".dsm";
	setAttr -s 5 ".bnds";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "FKShoulder_L_rotateX_BakeResults_inputB";
	rename -uid "9BC631AB-4521-7D2B-2C4D-E8BBDAA82158";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 5.4810541991890602 1 5.4810541991890602
		 2 5.4810541991890602 3 5.4810541991890602 4 5.4810541991890602 5 5.4810541991890602
		 6 5.4810541991890602 7 8.0315395612246441 8 13.642607357702929 9 19.253675154181213
		 10 21.804160516216797 11 12.656350390159965 12 -4.3324398439456093 13 -13.480249970002445
		 14 -13.480249970002445 15 -13.480249970002445 16 -13.480249970002445 17 -13.480249970002445
		 18 -13.480249970002445 19 -13.480249970002445 20 -13.480249970002445 21 -12.052541218973071
		 22 -8.4832693413996338 23 -3.8432159005541471 24 0.79683754029132325 25 4.3661094178647559
		 26 5.793818168894135;
createNode animCurveTA -n "FKShoulder_L_rotateY_BakeResults_inputB";
	rename -uid "20020A29-4E9F-1182-EE9E-5EBEBE5A2AFC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -28.582551868789455 1 -28.582551868789455
		 2 -28.582551868789455 3 -28.582551868789455 4 -28.582551868789455 5 -28.582551868789455
		 6 -28.582551868789455 7 -22.017569055559747 8 -7.5746068664543937 9 6.8683553226509577
		 10 13.433338135880669 11 6.7687407764552567 12 -5.6083686053348218 13 -12.272965964760226
		 14 -12.272965964760226 15 -12.272965964760226 16 -12.272965964760226 17 -12.272965964760226
		 18 -12.272965964760226 19 -12.272965964760226 20 -12.272965964760226 21 -12.430829042082658
		 22 -12.825486735388738 23 -13.338541736686643 24 -13.851596737984549 25 -14.246254431290629
		 26 -14.40411750861306;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder_L_rotate_BakeResults";
	rename -uid "E8E0C44D-4D95-28AE-2900-9383E625362E";
	setAttr ".o" -type "double3" 5.4810541991890602 -28.582551868789455 -1.2365855157636976 ;
createNode animCurveTA -n "FKShoulder_L_rotate_BakeResults_inputBZ";
	rename -uid "26E28078-40BE-BBFF-E1D7-D8A3CEB68859";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -1.2365855157636976 1 -1.2365855157636976
		 2 -1.2365855157636976 3 -1.2365855157636976 4 -1.2365855157636976 5 -1.2365855157636976
		 6 -1.2365855157636976 7 -0.54135920239801705 8 0.98813868700648011 9 2.5176365764109776
		 10 3.2128628897766593 11 -4.1855458059150976 12 -17.925447669342674 13 -25.32385636503443
		 14 -25.32385636503443 15 -25.32385636503443 16 -25.32385636503443 17 -25.32385636503443
		 18 -25.32385636503443 19 -25.32385636503443 20 -25.32385636503443 21 -23.531060185382252
		 22 -19.049069736251802 23 -13.222482152382193 24 -7.3958945685126034 25 -2.9139041193821531
		 26 -1.1211079397299721;
createNode animCurveTA -n "FKShoulder1_L_rotateX_BakeResults_inputB";
	rename -uid "D03CBBCF-49D0-B81B-C226-17952F55BAA1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 55.885188196645863 1 53.506278293290151
		 2 50.461067922977371 3 50.436325136592778 4 50.436325136592778 5 50.436325136592778
		 6 50.436325136592778 7 52.762944311772273 8 85.687415588738077 9 90.782454070358199
		 10 67.431460991235809 11 14.165428898941006 12 39.756155784316221 13 92.457455697362221
		 14 100.47119378569103 15 100.51158868945666 16 100.51158868945666 17 100.51158868945666
		 18 100.51158868945666 19 100.51158868945666 20 100.51530227068515 21 -377.04414345818424
		 22 -331.31250816174355 23 -141.38646985265615 24 219.06425444253532 25 43.560840070869169
		 26 48.762986135894657;
createNode animCurveTA -n "FKShoulder1_L_rotateY_BakeResults_inputB";
	rename -uid "CC1FA360-4D3C-F934-DE34-26A78AE0FC5C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -1.2883335215968093 1 -14.752394055675129
		 2 -18.622785471450978 3 -18.656459751770161 4 -18.656459751770161 5 -18.656459751770161
		 6 -18.656459751770161 7 -10.541051253004767 8 6.7061637274128394 9 15.056378402153957
		 10 60.808798013653821 11 104.07391704799244 12 122.21524736890085 13 133.32490025787206
		 14 136.56486610922508 15 136.6121739313439 16 136.6121739313439 17 136.6121739313439
		 18 136.6121739313439 19 136.6121739313439 20 136.61336376666327 21 51.704153486640955
		 22 52.317474898589104 23 -228.09431932692297 24 -212.53977948976632 25 5.0943106984151179
		 26 -16.329189569094222;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder1_L_rotate_BakeResults";
	rename -uid "CD7B3F5B-413F-4788-20E7-389B10F6F320";
	setAttr ".o" -type "double3" 50.436325136592778 -18.656459751770161 34.467147575161562 ;
createNode animCurveTA -n "FKShoulder1_L_rotate_BakeResults_inputBZ";
	rename -uid "6D70FCD8-431A-C707-8888-028B0FC0F213";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 32.577969924212439 1 33.781661119655375
		 2 34.455248055113998 3 34.467147575161562 4 34.467147575161562 5 34.467147575161562
		 6 34.467147575161562 7 50.318363279089233 8 81.617011899872054 9 101.23463125198822
		 10 83.219637215885214 11 41.606357219710333 12 77.603164007924505 13 124.04153481169847
		 14 127.98471601223473 15 127.87052659005495 16 127.87052659005495 17 127.87052659005495
		 18 127.87052659005495 19 127.87052659005495 20 127.87606234577844 21 -1.6375408474398512
		 22 43.049461088118548 23 -118.06937159156527 24 -129.05845062181874 25 39.533433490248058
		 26 34.16137391456374;
createNode animCurveTA -n "FKElbow_L_rotateX_BakeResults_inputB";
	rename -uid "C9F1950A-4255-B2C7-F3EF-84A10C6C2F96";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -2.3407948148086883 1 1.330539217158478
		 2 0.1897037762289622 3 0.00032140497019863857 4 3.1789427038925206e-12 5 3.1789427038925206e-12
		 6 3.1789427038925206e-12 7 -359.48525218629743 8 -363.21882225665229 9 -351.66867947203252
		 10 -354.46103582969567 11 -356.35699117737005 12 -2.3259170617981604 13 -6.8000929911285279
		 14 -0.0047631578036942636 15 -0.01739038169502212 16 1.8869266565935807e-12 17 1.8869266565935807e-12
		 18 1.8869266565935807e-12 19 1.8869266565935807e-12 20 0.0013732356004245352 21 1.693442066957654
		 22 4.0268410944753921 23 -1.152763868225924 24 -6.5698325527746206 25 -3.876988877453075
		 26 -1.6575957904298682;
createNode animCurveTA -n "FKElbow_L_rotateY_BakeResults_inputB";
	rename -uid "E2627C01-4038-0F40-6B5B-AF9C98CA377C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 4.2376596855758573 1 1.9491403222382255
		 2 0.029886324543803383 3 0.00022487750443280321 4 -8.2031421990152909e-12 5 -8.2031421990152909e-12
		 6 -8.2031421990152909e-12 7 -9.0699824542076701 8 -16.482153731702883 9 -6.6327048761791119
		 10 -9.2767436665837693 11 -8.3797218107820761 12 -1.1114467978562743 13 4.6021237415650154
		 14 0.10524355914204686 15 -0.015076814693335128 16 -8.111651072427225e-12 17 -8.111651072427225e-12
		 18 -8.111651072427225e-12 19 -8.111651072427225e-12 20 -0.00055283401726738141 21 8.5747966453844064
		 22 -8.0986567968766447 23 -0.71707964383730116 24 6.5948903443856457 25 9.1558992092656677
		 26 2.2781489714640961;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow_L_rotate_BakeResults";
	rename -uid "08EAB541-4561-4220-5BF7-A39EB519D949";
	setAttr ".o" -type "double3" 0.00032140497019863857 0.00022487750443280321 21.199280750230322 ;
createNode animCurveTA -n "FKElbow_L_rotate_BakeResults_inputBZ";
	rename -uid "73006C3F-4B73-B2EC-A34A-94BB252631B7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 16.687774318456494 1 17.985094464239577
		 2 20.927116405540918 3 21.199280750230322 4 21.199924359625623 5 21.199924359625623
		 6 21.199924359625623 7 383.57090126995638 8 391.5285875929701 9 395.8559491856858
		 10 392.19489437340701 11 388.45536341682771 12 388.26902180041708 13 26.437637441028325
		 14 21.279708424121793 15 21.20470934642778 16 21.199924359627769 17 21.199924359627769
		 18 21.199924359627769 19 21.199924359627769 20 21.201049595715151 21 13.456231701547559
		 22 369.12970929863531 23 374.011917643456 24 11.985450299249775 25 12.701673429934907
		 26 18.886612742485227;
createNode animCurveTA -n "FKElbow1_L_rotateX_BakeResults_inputB";
	rename -uid "BF39FC7B-46AB-A231-0EDF-BEB626C1F4D3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 181.93718698302681 1 181.38922572978746
		 2 180.61872881131896 3 359.99488073461413 4 360.00000593108274 5 360 6 360 7 354.54782652085623
		 8 350.25850843923348 9 357.23671618652924 10 362.60537011888692 11 358.41680612751128
		 12 358.56227845046766 13 179.65329773079222 14 179.91581658891303 15 359.99889898874193
		 16 359.99665869822167 17 359.99999999999824 18 359.99999999999824 19 359.99999999999824
		 20 360.00170470181229 21 185.03641518319566 22 182.47834842258499 23 178.49746775492707
		 24 179.71909924416931 25 178.95338586720422 26 179.9219881625331;
createNode animCurveTA -n "FKElbow1_L_rotateY_BakeResults_inputB";
	rename -uid "0E2CA9B5-4EF7-E719-644C-EEAAEAFB5EEB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -187.36254808867736 1 -181.86576126740763
		 2 -179.72743995991829 3 -0.0021996791424345684 4 -9.5477910992606474e-13 5 -9.5964049304776629e-13
		 6 -9.5964049304776629e-13 7 -2.6885409183145152 8 -10.261909122453256 9 -9.5024731322485891
		 10 -15.166164361370939 11 -9.4103617838435945 12 -2.3902775861281689 13 171.23344239364218
		 14 -181.56084880168686 15 0.0026275593515261921 16 -9.5659549872184016e-13 17 -9.579141107049632e-13
		 18 -9.579141107049632e-13 19 -9.579141107049632e-13 20 -0.0008301607348546496 21 -186.24475516877345
		 22 -172.35527875220538 23 -175.75910515805487 24 -188.83116549343325 25 -192.50500589416822
		 26 -184.54219570844003;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow1_L_rotate_BakeResults";
	rename -uid "96376BD3-4D0D-04FE-8D74-ACB767015C2F";
	setAttr ".o" -type "double3" 359.99488073461413 -0.0021996791424345684 -331.62233122852439 ;
createNode animCurveTA -n "FKElbow1_L_rotate_BakeResults_inputBZ";
	rename -uid "42185CAE-42BE-97A8-EFEB-CE98E76DADE6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -156.94829243650906 1 -155.47757558423919
		 2 -152.51827348493106 3 -331.62233122852439 4 -331.61618011745816 5 -331.61618011745816
		 6 -331.61618011745816 7 -331.17526145902394 8 -321.67674807802052 9 -319.40782562620143
		 10 -322.81567279031179 11 -325.08176011439917 12 -326.82356450715901 13 -144.80104117453638
		 14 -151.02639935297418 15 -331.61102948245997 16 -331.61618011745816 17 -331.61618011745816
		 18 -331.61618011745816 19 -331.61618011745816 20 -331.61514184645142 21 -158.87163021650355
		 22 -162.51458339211615 23 -161.41161882195442 24 -161.81237005601145 25 -162.44983244367302
		 26 -154.53991536116777;
createNode animCurveTA -n "FKWrist_L_rotateX_BakeResults_inputB";
	rename -uid "801C1C3D-4EB6-68F9-F0D4-6BAC67CD8F1E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -178.74848923498584 1 -178.0415412176495
		 2 -358.9448602313546 3 -359.99919468482523 4 -360.00007409713794 5 -360 6 -360 7 -364.13773160713049
		 8 -365.70450716720387 9 -364.2127843464246 10 -356.61964000540371 11 -359.03323231689285
		 12 -361.37401240969007 13 -181.31368368868047 14 -180.58705224317828 15 -360.00453945242629
		 16 -360.00423035245228 17 -360.00005216839105 18 -360.00000000000051 19 -360.00000000000051
		 20 -359.99926133490868 21 -176.01372212613794 22 -177.53175399310061 23 -362.23713954276394
		 24 -179.56769886572553 25 -178.79794108801062 26 -177.95100218478578;
createNode animCurveTA -n "FKWrist_L_rotateY_BakeResults_inputB";
	rename -uid "ADFB4B54-41A9-1CD0-E2BD-89947BA5643A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 169.93993426129566 1 176.3633936190495
		 2 -0.26054865872432903 3 -0.0089572637829976147 4 -2.8821477084550237e-06 5 -1.9752987063601281e-15
		 6 -1.9752987063601281e-15 7 0.96174385758109848 8 -1.2079456740575629 9 2.5311572011754726
		 10 -1.9890801626301897 11 -3.3546803060382775 12 -0.40067433975796246 13 172.33949031897072
		 14 175.92860055917964 15 0.03459448764703129 16 -0.00016454752433388018 17 -2.0291878162884285e-06
		 18 -1.6235045064080608e-14 19 -1.6235045064080608e-14 20 -0.00048601874157642587
		 21 173.72865430103548 22 184.00632035924937 23 -7.0451357518720892 24 172.83041037171023
		 25 166.69027092400648 26 173.18259780447931;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKWrist_L_rotate_BakeResults";
	rename -uid "9F25A1FF-41DF-324E-09FE-97AA831838B9";
	setAttr ".o" -type "double3" -359.99919468482523 -0.0089572637829976147 384.45880335720943 ;
createNode animCurveTA -n "FKWrist_L_rotate_BakeResults_inputBZ";
	rename -uid "956B582A-4A34-F482-CDDF-688544B8246A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 196.27833208360951 1 199.40314477813726
		 2 382.50050955541457 3 384.45880335720943 4 384.48656648963441 5 384.48656648963629
		 6 384.48656648963629 7 385.04028101588028 8 392.08474467375208 9 397.49608592277622
		 10 395.79560551238154 11 391.58223141158356 12 390.15698863289657 13 212.17792798040352
		 14 206.55416886973467 15 384.50658177825341 16 384.48656648356166 17 384.48656648963532
		 18 384.48656648963623 19 384.48656648963623 20 384.48739141386005 21 197.32147635908765
		 22 193.59344083947931 23 371.34676422264158 24 193.93681646933661 25 192.29428469061625
		 26 199.97546821166063;
createNode container -n "BakeResultsContainer";
	rename -uid "721AFC17-42D5-FEE3-1494-E0BEE17F55CB";
	setAttr ".isc" yes;
	setAttr ".ctor" -type "string" "codyr";
	setAttr ".cdat" -type "string" "2026/01/26 19:23:54";
createNode hyperLayout -n "hyperLayout1";
	rename -uid "A3AFB90A-4792-3A24-F9F3-EE938E6F9833";
	setAttr ".ihi" 0;
	setAttr -s 6 ".hyp";
createNode objectSet -n "OverlapperSet";
	rename -uid "F5F7D9C1-486D-0FD9-AC33-31806A8BE23E";
	setAttr ".ihi" 0;
	setAttr -s 5 ".dsm";
createNode animLayer -n "BakeResults1";
	rename -uid "9A9AD19A-4027-D4EE-D48F-38A9C13E4316";
	setAttr -s 15 ".dsm";
	setAttr -s 5 ".bnds";
	setAttr ".ovrd" yes;
createNode animCurveTA -n "FKShoulder_R_rotateX_BakeResults1_inputB";
	rename -uid "64B776A3-4209-4AAB-4012-1094A74E6EF4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0.70007021382882384
		 9 2.4502457484008833 10 4.7254739433445616 11 7.0007021382882408 12 8.7508776728603053
		 13 9.4509478866891268 14 9.4509478866891268 15 9.4509478866891268 16 9.4509478866891268
		 17 9.4509478866891268 18 9.4509478866891268 19 9.4509478866891268 20 8.9274259920911874
		 21 7.5772905797070278 22 5.7311870566511356 23 3.7197608300379916 24 1.873657306982099
		 25 0.52352189459794074 26 0;
createNode animCurveTA -n "FKShoulder_R_rotateY_BakeResults1_inputB";
	rename -uid "8D05F377-41AF-CAF8-3DC4-E697B510F8B2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 -1.2872735476880304
		 9 -4.505457416908107 10 -8.6890964468942062 11 -12.872735476880306 12 -16.090919346100392
		 13 -17.378192893788423 14 -17.378192893788423 15 -17.378192893788423 16 -17.378192893788423
		 17 -17.378192893788423 18 -17.378192893788423 19 -17.378192893788423 20 -16.415552471100433
		 21 -13.932953486273519 22 -10.538379364163246 23 -6.8398135296251743 24 -3.4452394075149018
		 25 -0.962640422687986 26 0;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder_R_rotate_BakeResults1";
	rename -uid "2F7629DB-4646-9ED5-A0DE-0D8E60FB32FD";
createNode animCurveTA -n "FKShoulder_R_rotate_BakeResults1_inputBZ";
	rename -uid "D5978ED2-49C9-176A-FACD-249F6F038B25";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 2.0368899423781048
		 9 7.1291147983233669 10 13.749007111052212 11 20.368899423781055 12 25.461124279726327
		 13 27.498014222104427 14 27.498014222104427 15 27.498014222104427 16 27.498014222104427
		 17 27.498014222104427 18 27.498014222104427 19 27.498014222104427 20 25.974800606302729
		 21 22.046512860287812 22 16.675180636144969 23 10.822833585959458 24 5.4515013618166135
		 25 1.5232136158016971 26 0;
createNode animCurveTA -n "FKShoulder1_R_rotateX_BakeResults1_inputB";
	rename -uid "BA44BA5E-41A2-7813-3EDE-7590E65018FA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -92.445530959297557 1 -92.969928546890941
		 2 -92.892935092182697 3 -92.892935092182697 4 -92.892935092182697 5 -92.892935092182697
		 6 -92.892935092182697 7 -92.894136974197508 8 -72.999843379195156 9 -55.30614043118532
		 10 -217.94018413333762 11 -189.42744193217908 12 20.557583828713089 13 42.247898421146338
		 14 44.308509958023244 15 44.315304589600586 16 44.315304589600586 17 44.315304589600586
		 18 44.315304589600586 19 44.315304589600586 20 50.354101792613228 21 -97.880276987608127
		 22 -91.076638591166471 23 -114.05075065358194 24 -173.75771007729264 25 -241.67543421384303
		 26 -92.288320145651582;
createNode animCurveTA -n "FKShoulder1_R_rotateY_BakeResults1_inputB";
	rename -uid "B4F1B1CD-4493-88BE-61FE-D29B839D0201";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -5.2485928303812264 1 -6.0610415305705754
		 2 -6.0571066442544668 3 -6.0571066442544668 4 -6.0571066442544668 5 -6.0571066442544668
		 6 -6.0571066442544668 7 -6.0527154648992427 8 -1.6432216471879599 9 -8.4086514745223617
		 10 -170.83859270418142 11 -183.51953594919974 12 -352.22386769259498 13 0.84339363010539981
		 14 -2.7617893807224538 15 -2.7831737043308182 16 -2.7831737043308182 17 -2.7831737043308182
		 18 -2.7831737043308182 19 -2.7831737043308182 20 0.21973590919108549 21 -183.54905278966518
		 22 -190.5629028410149 23 -203.33161861344891 24 156.45997758376217 25 172.58674502843141
		 26 -5.3049848004161557;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder1_R_rotate_BakeResults1";
	rename -uid "CB71498A-41D7-573C-BFE0-FFB27ECEF225";
	setAttr ".o" -type "double3" -92.892935092182697 -6.0571066442544668 -51.865139582994274 ;
createNode animCurveTA -n "FKShoulder1_R_rotate_BakeResults1_inputBZ";
	rename -uid "C0943EF6-4B8F-60D0-7764-618E0F301BFF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -49.112823400422272 1 -51.85505454440856
		 2 -51.865139582994274 3 -51.865139582994274 4 -51.865139582994274 5 -51.865139582994274
		 6 -51.865139582994274 7 -51.876843070617696 8 -61.019608483000773 9 -55.898186872522373
		 10 -208.0275905179316 11 -192.07987710032762 12 -2.0538528777343505 13 8.4487103855461445
		 14 10.631462537987481 15 10.642015868541977 16 10.642015868541977 17 10.642015868541977
		 18 10.642015868541977 19 10.642015868541977 20 17.71985810570996 21 -147.74034787992127
		 22 -134.82958819150974 23 -137.95251737989835 24 -166.44190180838635 25 -204.57911556102005
		 26 -49.318530700043276;
createNode animCurveTA -n "FKElbow_R_rotateX_BakeResults1_inputB";
	rename -uid "4B1E9450-4A6A-630E-EF7A-7D95BB0AD247";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 2.7320990869094981 1 0.01350912125121056
		 2 -0.011847416974554586 3 3.1145271773076352e-12 4 3.1145271773076352e-12 5 3.1145271773076352e-12
		 6 3.1145271773076352e-12 7 -0.00058240062930430827 8 0.29381920855536753 9 -0.4176958471533545
		 10 -10.596637010559174 11 -13.075109053400871 12 -10.824438768740507 13 -4.0211264288089206
		 14 0.15075727945739364 15 -6.3865277636256269e-05 16 6.770215014217734e-12 17 6.770215014217734e-12
		 18 6.770215014217734e-12 19 6.770215014217734e-12 20 -0.23980982720986874 21 1.3736094056597608
		 22 7.9681296368528711 23 7.1635984810491538 24 8.2085198824455574 25 8.9929791243793549
		 26 2.2873671462653129;
createNode animCurveTA -n "FKElbow_R_rotateY_BakeResults1_inputB";
	rename -uid "DF074614-42F1-06EB-7209-1D94C74FE50C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -5.8383938383845413 1 -0.061031034306168734
		 2 -0.0010188882945908666 3 -1.1374985814789417e-11 4 -1.1374985814789417e-11 5 -1.1374985814789417e-11
		 6 -1.1374985814789417e-11 7 0.0012350790584457398 8 5.7300589433256643 9 10.202813519593809
		 10 4.8857192648743109 11 2.5554261401556557 12 4.7132075589769693 13 1.7490163691139931
		 14 0.079911223406952378 15 -1.7487548709400284e-05 16 -1.1640895961108229e-11 17 -1.1640895961108229e-11
		 18 -1.1640895961108229e-11 19 -1.1640895961108229e-11 20 -4.0372756935029575 21 -10.858892536909073
		 22 -6.7518968956581418 23 -2.4165278806816413 24 6.1364248643504435 25 -5.6253038527895773
		 26 -4.3955994578097499;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow_R_rotate_BakeResults1";
	rename -uid "459875A2-4E5C-363D-AB36-6BB1574BC4DE";
	setAttr ".o" -type "double3" 3.1145271773076352e-12 -1.1374985814789417e-11 15.313330745096986 ;
createNode animCurveTA -n "FKElbow_R_rotate_BakeResults1_inputBZ";
	rename -uid "6EC6128B-4D38-5004-4E21-43BB4483FF24";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 17.943908515057835 1 15.3139160960488
		 2 15.312603053668509 3 15.313330745096986 4 15.313330745096986 5 15.313330745096986
		 6 15.313330745096986 7 15.315245934897291 8 15.309181821333539 9 9.3044003866788643
		 10 5.5760902476292156 11 8.7546166312459874 12 7.0315428660774604 13 9.6084115269075578
		 14 15.217529910917259 15 15.313330745084441 16 15.313330745094181 17 15.313330745094181
		 18 15.313330745094181 19 15.313330745094181 20 15.81073817266576 21 25.278877872043392
		 22 25.978523124392058 23 20.606166363995317 24 25.718020210228339 25 30.452657655371077
		 26 17.428472191572769;
createNode animCurveTA -n "FKElbow1_R_rotateX_BakeResults1_inputB";
	rename -uid "B996EDF4-4F5F-C7E2-9A15-44B0BB4A658B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -0.64744619916835322 1 -0.4984675788702258
		 2 -0.0029963260288870183 3 -0.00094610029202170127 4 0 5 0 6 0 7 -0.0010129397992949202
		 8 1.4469103615185896 9 2.1697266848827139 10 -3.4768534111694098 11 -11.238353589876494
		 12 -11.923515208930574 13 -3.7949804054621796 14 0.25520230836822144 15 0.0025954426035100504
		 16 -3.0022401248781399e-06 17 3.4232877502874291e-12 18 3.4232877502874291e-12 19 3.4232877502874291e-12
		 20 -1.67210296013102 21 -3.5544669225120828 22 0.32178228755365385 23 6.2407997164800779
		 24 9.1232517036853356 25 0.95517451189200708 26 -0.39310665735964362;
createNode animCurveTA -n "FKElbow1_R_rotateY_BakeResults1_inputB";
	rename -uid "340DA725-4910-43A9-FDB9-B28D5D0B77F0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -10.504649686867527 1 -0.59665694957298177
		 2 -0.001053218601882332 3 0.0011368667848009005 4 0 5 0 6 0 7 0.00082491076674458144
		 8 3.1006473069202323 9 9.5451742293401018 10 11.592160226792819 11 8.7296704597113539
		 12 10.922305620220802 13 6.3010671160830949 14 0.3277672633135314 15 -0.00015701802093307031
		 16 3.6292311964617317e-16 17 1.2463275335680496e-15 18 1.2463275335680496e-15 19 1.2463275335680496e-15
		 20 -2.2631871328308586 21 -9.1832561867409392 22 -13.568792818478464 23 -8.337341018471248
		 24 -2.3920010864088672 25 -9.9757258769561368 26 -6.9231871292210672;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow1_R_rotate_BakeResults1";
	rename -uid "7B631257-449B-BBEF-48BF-5A954246A0D4";
	setAttr ".o" -type "double3" -0.00094610029202170127 0.0011368667848009005 24.363298721104204 ;
createNode animCurveTA -n "FKElbow1_R_rotate_BakeResults1_inputBZ";
	rename -uid "56998D3F-465D-71AA-F983-59AA5A9ACC05";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 30.468284585071473 1 24.518415556683301
		 2 24.361567401205559 3 24.363298721104204 4 24.363436449417232 5 24.363436449417232
		 6 24.363436449417232 7 24.362056612890427 8 23.436123844178638 9 19.637773848936131
		 10 13.716897262533172 11 14.031430405048972 12 14.004542620004228 13 15.893775961181522
		 14 23.501458441478903 15 24.361127600173916 16 24.363436449417232 17 24.363436449417225
		 18 24.363436449417225 19 24.363436449417225 20 24.41139286716059 21 33.051029497346015
		 22 36.288090038179895 23 27.441056298415866 24 30.599248006165258 25 38.999055767340778
		 26 29.156143860426159;
createNode animCurveTA -n "FKWrist_R_rotateX_BakeResults1_inputB";
	rename -uid "F06BB626-498D-B808-9092-5BB5223D480B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -4.0849616619734537 1 -8.0271095746515559
		 2 -7.6030284896879783 3 -7.5891909951086927 4 -7.5886299978936824 5 -7.588535528806573
		 6 -7.588535528806573 7 -7.5894746253718752 8 -6.8072921686827401 9 -5.7924777679870774
		 10 -9.7162026293744024 11 -17.763777211462319 12 -22.054665265875794 13 -13.164158658678305
		 14 -8.3964257023660362 15 -7.5860515618071176 16 -7.588497116819851 17 -7.5885355288032814
		 18 -7.5885355288032814 19 -7.5885355288032814 20 -9.2071837712700209 21 -9.4410615722634628
		 22 -2.4112498636274906 23 -1.0957328172027412 24 3.0541982116516939 25 1.12167542505843
		 26 -5.9627652407034919;
createNode animCurveTA -n "FKWrist_R_rotateY_BakeResults1_inputB";
	rename -uid "77BE49E8-48DE-39F9-272A-6C80628B47D5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 -28.202337939115736 1 -16.829372977709177
		 2 -14.137891339559753 3 -14.122144974281232 4 -14.123731190865097 5 -14.123727553195971
		 6 -14.123727553195971 7 -14.127331753219886 8 -12.678848680394987 9 -4.4001830051398327
		 10 1.0734667829980058 11 -0.75697604696384302 12 0.049863571138998572 13 -3.2504821096625327
		 14 -12.329885347624588 15 -14.114755461339708 16 -14.123726074086498 17 -14.123727553195843
		 18 -14.123727553195843 19 -14.123727553195843 20 -13.29078036648828 21 -15.169290157773144
		 22 -17.211318574375575 23 -13.626030518656512 24 -11.216807594334394 25 -21.228104169496781
		 26 -22.672185502364034;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKWrist_R_rotate_BakeResults1";
	rename -uid "136167E5-49DC-FBD7-6B85-ABBA92A7A041";
	setAttr ".o" -type "double3" -7.5891909951086927 -14.122144974281232 20.326189250748072 ;
createNode animCurveTA -n "FKWrist_R_rotate_BakeResults1_inputBZ";
	rename -uid "DBD7E741-44B9-9B71-2CBF-B4857A602635";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 27 ".ktv[0:26]"  0 30.361852274812463 1 20.717590333395311
		 2 20.319837255279818 3 20.326189250748072 4 20.32650786061955 5 20.326508360357035
		 6 20.326508360357035 7 20.325575644591872 8 20.53259418543638 9 21.290586712836664
		 10 10.900016710358177 11 13.775482097584693 12 14.664227045926953 13 11.316625619217556
		 14 17.803548268790635 15 20.306467718221441 16 20.32650856355303 17 20.326508360357042
		 18 20.326508360357042 19 20.326508360357042 20 20.398345251590321 21 26.700588481660485
		 22 32.660486127028513 23 24.612629649003907 24 25.411068933027693 25 34.4299101582044
		 26 26.651912049633182;
createNode container -n "BakeResults1Container";
	rename -uid "D33969B0-483D-B94E-F099-0DA2B386D88E";
	setAttr ".isc" yes;
	setAttr ".ctor" -type "string" "codyr";
	setAttr ".cdat" -type "string" "2026/01/26 19:24:54";
createNode hyperLayout -n "hyperLayout2";
	rename -uid "BF2CA88D-4EA1-F647-72E3-508721C985C5";
	setAttr ".ihi" 0;
	setAttr -s 6 ".hyp";
createNode gameFbxExporter -n "gameExporterPreset1";
	rename -uid "A5E18F9D-4EDA-1A1D-C81C-1183CC6DB29D";
	setAttr ".pn" -type "string" "Model Default";
	setAttr ".ils" yes;
	setAttr ".ssn" -type "string" "";
	setAttr ".ebm" yes;
	setAttr ".ich" yes;
	setAttr ".inc" yes;
	setAttr ".fv" -type "string" "FBX201800";
	setAttr ".exp" -type "string" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Export";
createNode gameFbxExporter -n "gameExporterPreset2";
	rename -uid "7C25051C-4655-A62E-6B62-558961F044E4";
	setAttr ".pn" -type "string" "Anim Default";
	setAttr ".ils" yes;
	setAttr ".ilu" yes;
	setAttr ".eti" 2;
	setAttr ".esi" 2;
	setAttr ".ssn" -type "string" "";
	setAttr ".ac[0].acn" -type "string" "Skate_Loop";
	setAttr ".ac[0].ace" 26;
	setAttr ".spt" 2;
	setAttr ".ic" no;
	setAttr ".ebm" yes;
	setAttr ".fv" -type "string" "FBX201800";
	setAttr ".exp" -type "string" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Export";
createNode gameFbxExporter -n "gameExporterPreset3";
	rename -uid "976C8CE0-4D49-B262-03BF-80A4BE194FFA";
	setAttr ".pn" -type "string" "TE Anim Default";
	setAttr ".ils" yes;
	setAttr ".eti" 3;
	setAttr ".ssn" -type "string" "";
	setAttr ".ebm" yes;
	setAttr ".fv" -type "string" "FBX201800";
select -ne :time1;
	setAttr ".o" 3;
	setAttr ".unw" 3;
select -ne :hardwareRenderingGlobals;
	setAttr ".otfna" -type "stringArray" 22 "NURBS Curves" "NURBS Surfaces" "Polygons" "Subdiv Surface" "Particles" "Particle Instance" "Fluids" "Strokes" "Image Planes" "UI" "Lights" "Cameras" "Locators" "Joints" "IK Handles" "Deformers" "Motion Trails" "Components" "Hair Systems" "Follicles" "Misc. UI" "Ornaments"  ;
	setAttr ".otfva" -type "Int32Array" 22 0 1 1 1 1 1
		 1 1 1 0 0 0 0 0 0 0 0 0
		 0 0 0 0 ;
	setAttr ".fprt" yes;
select -ne :renderPartition;
	setAttr -s 24 ".st";
select -ne :renderGlobalsList1;
select -ne :defaultShaderList1;
	setAttr -s 20 ".s";
select -ne :postProcessList1;
	setAttr -s 2 ".p";
select -ne :defaultRenderUtilityList1;
	setAttr -s 7 ".u";
select -ne :defaultRenderingList1;
	setAttr -s 2 ".r";
select -ne :defaultTextureList1;
	setAttr -s 5 ".tx";
select -ne :initialShadingGroup;
	setAttr ".ro" yes;
select -ne :initialParticleSE;
	setAttr ".ro" yes;
select -ne :defaultRenderGlobals;
	addAttr -ci true -h true -sn "dss" -ln "defaultSurfaceShader" -dt "string";
	setAttr ".mcfr" 30;
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
	setAttr ".hwfr" 30;
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
connectAttr "Main_translateX.o" "Sid_RigRN.phl[19]";
connectAttr "Main_translateY.o" "Sid_RigRN.phl[20]";
connectAttr "Main_translateZ.o" "Sid_RigRN.phl[21]";
connectAttr "Main_rotateX.o" "Sid_RigRN.phl[22]";
connectAttr "Main_rotateY.o" "Sid_RigRN.phl[23]";
connectAttr "Main_rotateZ.o" "Sid_RigRN.phl[24]";
connectAttr "FKToes_R_rotateX.o" "Sid_RigRN.phl[25]";
connectAttr "FKToes_R_rotateY.o" "Sid_RigRN.phl[26]";
connectAttr "FKToes_R_rotateZ.o" "Sid_RigRN.phl[27]";
connectAttr "FKHead_M_translateX.o" "Sid_RigRN.phl[28]";
connectAttr "FKHead_M_translateY.o" "Sid_RigRN.phl[29]";
connectAttr "FKHead_M_translateZ.o" "Sid_RigRN.phl[30]";
connectAttr "FKHead_M_rotateZ.o" "Sid_RigRN.phl[31]";
connectAttr "FKHead_M_rotateX.o" "Sid_RigRN.phl[32]";
connectAttr "FKHead_M_rotateY.o" "Sid_RigRN.phl[33]";
connectAttr "Bigote02_Ctrl_translateX.o" "Sid_RigRN.phl[34]";
connectAttr "Bigote02_Ctrl_translateY.o" "Sid_RigRN.phl[35]";
connectAttr "Bigote02_Ctrl_translateZ.o" "Sid_RigRN.phl[36]";
connectAttr "Bigote02_Ctrl_rotateX.o" "Sid_RigRN.phl[37]";
connectAttr "Bigote02_Ctrl_rotateY.o" "Sid_RigRN.phl[38]";
connectAttr "Bigote02_Ctrl_rotateZ.o" "Sid_RigRN.phl[39]";
connectAttr "Bigote02_Ctrl_scaleX.o" "Sid_RigRN.phl[40]";
connectAttr "Bigote02_Ctrl_scaleY.o" "Sid_RigRN.phl[41]";
connectAttr "Bigote02_Ctrl_scaleZ.o" "Sid_RigRN.phl[42]";
connectAttr "Bigote02_Ctrl_visibility.o" "Sid_RigRN.phl[43]";
connectAttr "Bigote01_Ctrl_translateX.o" "Sid_RigRN.phl[44]";
connectAttr "Bigote01_Ctrl_translateY.o" "Sid_RigRN.phl[45]";
connectAttr "Bigote01_Ctrl_translateZ.o" "Sid_RigRN.phl[46]";
connectAttr "Bigote01_Ctrl_rotateX.o" "Sid_RigRN.phl[47]";
connectAttr "Bigote01_Ctrl_rotateY.o" "Sid_RigRN.phl[48]";
connectAttr "Bigote01_Ctrl_rotateZ.o" "Sid_RigRN.phl[49]";
connectAttr "Bigote01_Ctrl_scaleX.o" "Sid_RigRN.phl[50]";
connectAttr "Bigote01_Ctrl_scaleY.o" "Sid_RigRN.phl[51]";
connectAttr "Bigote01_Ctrl_scaleZ.o" "Sid_RigRN.phl[52]";
connectAttr "Bigote01_Ctrl_visibility.o" "Sid_RigRN.phl[53]";
connectAttr "Gorro_Ctrl_translateX.o" "Sid_RigRN.phl[54]";
connectAttr "Gorro_Ctrl_translateY.o" "Sid_RigRN.phl[55]";
connectAttr "Gorro_Ctrl_translateZ.o" "Sid_RigRN.phl[56]";
connectAttr "Gorro_Ctrl_rotateZ.o" "Sid_RigRN.phl[57]";
connectAttr "Gorro_Ctrl_rotateX.o" "Sid_RigRN.phl[58]";
connectAttr "Gorro_Ctrl_rotateY.o" "Sid_RigRN.phl[59]";
connectAttr "Sid_RigRN.phl[60]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[61]";
connectAttr "Sid_RigRN.phl[62]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[63]";
connectAttr "Sid_RigRN.phl[64]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[65]";
connectAttr "Sid_RigRN.phl[66]" "Sid_Rig:FKShoulder_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[67]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[68]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[69]";
connectAttr "Sid_RigRN.phl[70]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[71]";
connectAttr "Sid_RigRN.phl[72]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[73]";
connectAttr "Sid_RigRN.phl[74]" "Sid_Rig:FKShoulder1_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[75]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[76]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[77]";
connectAttr "Sid_RigRN.phl[78]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[79]";
connectAttr "Sid_RigRN.phl[80]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[81]";
connectAttr "Sid_RigRN.phl[82]" "Sid_Rig:FKElbow_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[83]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[84]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[85]";
connectAttr "Sid_RigRN.phl[86]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[87]";
connectAttr "Sid_RigRN.phl[88]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[89]";
connectAttr "Sid_RigRN.phl[90]" "Sid_Rig:FKElbow1_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[91]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[92]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.ox" "Sid_RigRN.phl[93]";
connectAttr "Sid_RigRN.phl[94]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.oy" "Sid_RigRN.phl[95]";
connectAttr "Sid_RigRN.phl[96]" "BakeResults1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_BakeResults1.oz" "Sid_RigRN.phl[97]";
connectAttr "Sid_RigRN.phl[98]" "Sid_Rig:FKWrist_R_rotate_BakeResults1.ro";
connectAttr "Sid_RigRN.phl[99]" "OverlapperSet.dsm" -na;
connectAttr "Sid_RigRN.phl[100]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.ox" "Sid_RigRN.phl[101]";
connectAttr "Sid_RigRN.phl[102]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.oy" "Sid_RigRN.phl[103]";
connectAttr "Sid_RigRN.phl[104]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder_L_rotate_BakeResults.oz" "Sid_RigRN.phl[105]";
connectAttr "Sid_RigRN.phl[106]" "Sid_Rig:FKShoulder_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[107]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.oz" "Sid_RigRN.phl[108]";
connectAttr "Sid_RigRN.phl[109]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.ox" "Sid_RigRN.phl[110]";
connectAttr "Sid_RigRN.phl[111]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_BakeResults.oy" "Sid_RigRN.phl[112]";
connectAttr "Sid_RigRN.phl[113]" "Sid_Rig:FKShoulder1_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[114]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.ox" "Sid_RigRN.phl[115]";
connectAttr "Sid_RigRN.phl[116]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.oy" "Sid_RigRN.phl[117]";
connectAttr "Sid_RigRN.phl[118]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_BakeResults.oz" "Sid_RigRN.phl[119]";
connectAttr "Sid_RigRN.phl[120]" "Sid_Rig:FKElbow_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[121]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.ox" "Sid_RigRN.phl[122]";
connectAttr "Sid_RigRN.phl[123]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.oy" "Sid_RigRN.phl[124]";
connectAttr "Sid_RigRN.phl[125]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_BakeResults.oz" "Sid_RigRN.phl[126]";
connectAttr "Sid_RigRN.phl[127]" "Sid_Rig:FKElbow1_L_rotate_BakeResults.ro";
connectAttr "Sid_RigRN.phl[128]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.ox" "Sid_RigRN.phl[129]";
connectAttr "Sid_RigRN.phl[130]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.oy" "Sid_RigRN.phl[131]";
connectAttr "Sid_RigRN.phl[132]" "BakeResults.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_BakeResults.oz" "Sid_RigRN.phl[133]";
connectAttr "Sid_RigRN.phl[134]" "Sid_Rig:FKWrist_L_rotate_BakeResults.ro";
connectAttr "FKMiddleFinger1_R_rotateX.o" "Sid_RigRN.phl[135]";
connectAttr "FKMiddleFinger1_R_rotateY.o" "Sid_RigRN.phl[136]";
connectAttr "FKMiddleFinger1_R_rotateZ.o" "Sid_RigRN.phl[137]";
connectAttr "FKMiddleFinger2_R_rotateX.o" "Sid_RigRN.phl[138]";
connectAttr "FKMiddleFinger2_R_rotateY.o" "Sid_RigRN.phl[139]";
connectAttr "FKMiddleFinger2_R_rotateZ.o" "Sid_RigRN.phl[140]";
connectAttr "FKMiddleFinger3_R_rotateX.o" "Sid_RigRN.phl[141]";
connectAttr "FKMiddleFinger3_R_rotateY.o" "Sid_RigRN.phl[142]";
connectAttr "FKMiddleFinger3_R_rotateZ.o" "Sid_RigRN.phl[143]";
connectAttr "FKThumbFinger1_R_rotateX.o" "Sid_RigRN.phl[144]";
connectAttr "FKThumbFinger1_R_rotateY.o" "Sid_RigRN.phl[145]";
connectAttr "FKThumbFinger1_R_rotateZ.o" "Sid_RigRN.phl[146]";
connectAttr "FKThumbFinger2_R_rotateX.o" "Sid_RigRN.phl[147]";
connectAttr "FKThumbFinger2_R_rotateY.o" "Sid_RigRN.phl[148]";
connectAttr "FKThumbFinger2_R_rotateZ.o" "Sid_RigRN.phl[149]";
connectAttr "FKThumbFinger3_R_rotateX.o" "Sid_RigRN.phl[150]";
connectAttr "FKThumbFinger3_R_rotateY.o" "Sid_RigRN.phl[151]";
connectAttr "FKThumbFinger3_R_rotateZ.o" "Sid_RigRN.phl[152]";
connectAttr "FKIndexFinger1_R_rotateX.o" "Sid_RigRN.phl[153]";
connectAttr "FKIndexFinger1_R_rotateY.o" "Sid_RigRN.phl[154]";
connectAttr "FKIndexFinger1_R_rotateZ.o" "Sid_RigRN.phl[155]";
connectAttr "FKIndexFinger2_R_rotateX.o" "Sid_RigRN.phl[156]";
connectAttr "FKIndexFinger2_R_rotateY.o" "Sid_RigRN.phl[157]";
connectAttr "FKIndexFinger2_R_rotateZ.o" "Sid_RigRN.phl[158]";
connectAttr "FKIndexFinger3_R_rotateX.o" "Sid_RigRN.phl[159]";
connectAttr "FKIndexFinger3_R_rotateY.o" "Sid_RigRN.phl[160]";
connectAttr "FKIndexFinger3_R_rotateZ.o" "Sid_RigRN.phl[161]";
connectAttr "FKPinkyFinger1_R_rotateX.o" "Sid_RigRN.phl[162]";
connectAttr "FKPinkyFinger1_R_rotateY.o" "Sid_RigRN.phl[163]";
connectAttr "FKPinkyFinger1_R_rotateZ.o" "Sid_RigRN.phl[164]";
connectAttr "FKPinkyFinger2_R_rotateX.o" "Sid_RigRN.phl[165]";
connectAttr "FKPinkyFinger2_R_rotateY.o" "Sid_RigRN.phl[166]";
connectAttr "FKPinkyFinger2_R_rotateZ.o" "Sid_RigRN.phl[167]";
connectAttr "FKPinkyFinger3_R_rotateX.o" "Sid_RigRN.phl[168]";
connectAttr "FKPinkyFinger3_R_rotateY.o" "Sid_RigRN.phl[169]";
connectAttr "FKPinkyFinger3_R_rotateZ.o" "Sid_RigRN.phl[170]";
connectAttr "FKRootPart1_M_translateX.o" "Sid_RigRN.phl[171]";
connectAttr "FKRootPart1_M_translateY.o" "Sid_RigRN.phl[172]";
connectAttr "FKRootPart1_M_translateZ.o" "Sid_RigRN.phl[173]";
connectAttr "FKRootPart1_M_rotateX.o" "Sid_RigRN.phl[174]";
connectAttr "FKRootPart1_M_rotateY.o" "Sid_RigRN.phl[175]";
connectAttr "FKRootPart1_M_rotateZ.o" "Sid_RigRN.phl[176]";
connectAttr "FKRootPart2_M_translateX.o" "Sid_RigRN.phl[177]";
connectAttr "FKRootPart2_M_translateY.o" "Sid_RigRN.phl[178]";
connectAttr "FKRootPart2_M_translateZ.o" "Sid_RigRN.phl[179]";
connectAttr "FKRootPart2_M_rotateX.o" "Sid_RigRN.phl[180]";
connectAttr "FKRootPart2_M_rotateY.o" "Sid_RigRN.phl[181]";
connectAttr "FKRootPart2_M_rotateZ.o" "Sid_RigRN.phl[182]";
connectAttr "FKSpine1_M_translateX.o" "Sid_RigRN.phl[183]";
connectAttr "FKSpine1_M_translateY.o" "Sid_RigRN.phl[184]";
connectAttr "FKSpine1_M_translateZ.o" "Sid_RigRN.phl[185]";
connectAttr "FKSpine1_M_rotateX.o" "Sid_RigRN.phl[186]";
connectAttr "FKSpine1_M_rotateY.o" "Sid_RigRN.phl[187]";
connectAttr "FKSpine1_M_rotateZ.o" "Sid_RigRN.phl[188]";
connectAttr "FKSpine1Part1_M_translateX.o" "Sid_RigRN.phl[189]";
connectAttr "FKSpine1Part1_M_translateY.o" "Sid_RigRN.phl[190]";
connectAttr "FKSpine1Part1_M_translateZ.o" "Sid_RigRN.phl[191]";
connectAttr "FKSpine1Part1_M_rotateX.o" "Sid_RigRN.phl[192]";
connectAttr "FKSpine1Part1_M_rotateY.o" "Sid_RigRN.phl[193]";
connectAttr "FKSpine1Part1_M_rotateZ.o" "Sid_RigRN.phl[194]";
connectAttr "FKSpine1Part2_M_translateX.o" "Sid_RigRN.phl[195]";
connectAttr "FKSpine1Part2_M_translateY.o" "Sid_RigRN.phl[196]";
connectAttr "FKSpine1Part2_M_translateZ.o" "Sid_RigRN.phl[197]";
connectAttr "FKSpine1Part2_M_rotateX.o" "Sid_RigRN.phl[198]";
connectAttr "FKSpine1Part2_M_rotateY.o" "Sid_RigRN.phl[199]";
connectAttr "FKSpine1Part2_M_rotateZ.o" "Sid_RigRN.phl[200]";
connectAttr "FKChest_M_translateX.o" "Sid_RigRN.phl[201]";
connectAttr "FKChest_M_translateY.o" "Sid_RigRN.phl[202]";
connectAttr "FKChest_M_translateZ.o" "Sid_RigRN.phl[203]";
connectAttr "FKChest_M_rotateX.o" "Sid_RigRN.phl[204]";
connectAttr "FKChest_M_rotateY.o" "Sid_RigRN.phl[205]";
connectAttr "FKChest_M_rotateZ.o" "Sid_RigRN.phl[206]";
connectAttr "FKRoot_M_rotateX.o" "Sid_RigRN.phl[207]";
connectAttr "FKRoot_M_rotateY.o" "Sid_RigRN.phl[208]";
connectAttr "FKRoot_M_rotateZ.o" "Sid_RigRN.phl[209]";
connectAttr "FKToes_L_rotateX.o" "Sid_RigRN.phl[210]";
connectAttr "FKToes_L_rotateY.o" "Sid_RigRN.phl[211]";
connectAttr "FKToes_L_rotateZ.o" "Sid_RigRN.phl[212]";
connectAttr "FKMiddleFinger1_L_rotateX.o" "Sid_RigRN.phl[213]";
connectAttr "FKMiddleFinger1_L_rotateY.o" "Sid_RigRN.phl[214]";
connectAttr "FKMiddleFinger1_L_rotateZ.o" "Sid_RigRN.phl[215]";
connectAttr "FKMiddleFinger2_L_rotateX.o" "Sid_RigRN.phl[216]";
connectAttr "FKMiddleFinger2_L_rotateY.o" "Sid_RigRN.phl[217]";
connectAttr "FKMiddleFinger2_L_rotateZ.o" "Sid_RigRN.phl[218]";
connectAttr "FKMiddleFinger3_L_rotateX.o" "Sid_RigRN.phl[219]";
connectAttr "FKMiddleFinger3_L_rotateY.o" "Sid_RigRN.phl[220]";
connectAttr "FKMiddleFinger3_L_rotateZ.o" "Sid_RigRN.phl[221]";
connectAttr "FKThumbFinger1_L_rotateX.o" "Sid_RigRN.phl[222]";
connectAttr "FKThumbFinger1_L_rotateY.o" "Sid_RigRN.phl[223]";
connectAttr "FKThumbFinger1_L_rotateZ.o" "Sid_RigRN.phl[224]";
connectAttr "FKThumbFinger2_L_rotateX.o" "Sid_RigRN.phl[225]";
connectAttr "FKThumbFinger2_L_rotateY.o" "Sid_RigRN.phl[226]";
connectAttr "FKThumbFinger2_L_rotateZ.o" "Sid_RigRN.phl[227]";
connectAttr "FKThumbFinger3_L_rotateX.o" "Sid_RigRN.phl[228]";
connectAttr "FKThumbFinger3_L_rotateY.o" "Sid_RigRN.phl[229]";
connectAttr "FKThumbFinger3_L_rotateZ.o" "Sid_RigRN.phl[230]";
connectAttr "FKIndexFinger1_L_rotateX.o" "Sid_RigRN.phl[231]";
connectAttr "FKIndexFinger1_L_rotateY.o" "Sid_RigRN.phl[232]";
connectAttr "FKIndexFinger1_L_rotateZ.o" "Sid_RigRN.phl[233]";
connectAttr "FKIndexFinger2_L_rotateX.o" "Sid_RigRN.phl[234]";
connectAttr "FKIndexFinger2_L_rotateY.o" "Sid_RigRN.phl[235]";
connectAttr "FKIndexFinger2_L_rotateZ.o" "Sid_RigRN.phl[236]";
connectAttr "FKIndexFinger3_L_rotateX.o" "Sid_RigRN.phl[237]";
connectAttr "FKIndexFinger3_L_rotateY.o" "Sid_RigRN.phl[238]";
connectAttr "FKIndexFinger3_L_rotateZ.o" "Sid_RigRN.phl[239]";
connectAttr "FKPinkyFinger1_L_rotateX.o" "Sid_RigRN.phl[240]";
connectAttr "FKPinkyFinger1_L_rotateY.o" "Sid_RigRN.phl[241]";
connectAttr "FKPinkyFinger1_L_rotateZ.o" "Sid_RigRN.phl[242]";
connectAttr "FKPinkyFinger2_L_rotateX.o" "Sid_RigRN.phl[243]";
connectAttr "FKPinkyFinger2_L_rotateY.o" "Sid_RigRN.phl[244]";
connectAttr "FKPinkyFinger2_L_rotateZ.o" "Sid_RigRN.phl[245]";
connectAttr "FKPinkyFinger3_L_rotateX.o" "Sid_RigRN.phl[246]";
connectAttr "FKPinkyFinger3_L_rotateY.o" "Sid_RigRN.phl[247]";
connectAttr "FKPinkyFinger3_L_rotateZ.o" "Sid_RigRN.phl[248]";
connectAttr "HipSwinger_M_rotateX.o" "Sid_RigRN.phl[249]";
connectAttr "HipSwinger_M_rotateY.o" "Sid_RigRN.phl[250]";
connectAttr "HipSwinger_M_rotateZ.o" "Sid_RigRN.phl[251]";
connectAttr "HipSwinger_M_stabilize.o" "Sid_RigRN.phl[252]";
connectAttr "IKSpine1_M_translateX.o" "Sid_RigRN.phl[253]";
connectAttr "IKSpine1_M_translateY.o" "Sid_RigRN.phl[254]";
connectAttr "IKSpine1_M_translateZ.o" "Sid_RigRN.phl[255]";
connectAttr "IKSpine1_M_rotateX.o" "Sid_RigRN.phl[256]";
connectAttr "IKSpine1_M_rotateY.o" "Sid_RigRN.phl[257]";
connectAttr "IKSpine1_M_rotateZ.o" "Sid_RigRN.phl[258]";
connectAttr "IKSpine2_M_translateX.o" "Sid_RigRN.phl[259]";
connectAttr "IKSpine2_M_translateY.o" "Sid_RigRN.phl[260]";
connectAttr "IKSpine2_M_translateZ.o" "Sid_RigRN.phl[261]";
connectAttr "IKSpine2_M_rotateX.o" "Sid_RigRN.phl[262]";
connectAttr "IKSpine2_M_rotateY.o" "Sid_RigRN.phl[263]";
connectAttr "IKSpine2_M_rotateZ.o" "Sid_RigRN.phl[264]";
connectAttr "IKLeg_R_translateX.o" "Sid_RigRN.phl[265]";
connectAttr "IKLeg_R_translateY.o" "Sid_RigRN.phl[266]";
connectAttr "IKLeg_R_translateZ.o" "Sid_RigRN.phl[267]";
connectAttr "IKLeg_R_rotateY.o" "Sid_RigRN.phl[268]";
connectAttr "IKLeg_R_rotateX.o" "Sid_RigRN.phl[269]";
connectAttr "IKLeg_R_rotateZ.o" "Sid_RigRN.phl[270]";
connectAttr "IKLeg_R_toe.o" "Sid_RigRN.phl[271]";
connectAttr "IKLeg_R_rollAngle.o" "Sid_RigRN.phl[272]";
connectAttr "IKLeg_R_roll.o" "Sid_RigRN.phl[273]";
connectAttr "IKLeg_R_stretchy.o" "Sid_RigRN.phl[274]";
connectAttr "IKLeg_R_antiPop.o" "Sid_RigRN.phl[275]";
connectAttr "IKLeg_R_Lenght1.o" "Sid_RigRN.phl[276]";
connectAttr "IKLeg_R_Lenght2.o" "Sid_RigRN.phl[277]";
connectAttr "IKLeg_R_volume.o" "Sid_RigRN.phl[278]";
connectAttr "RollHeel_R_translateX.o" "Sid_RigRN.phl[279]";
connectAttr "RollHeel_R_translateY.o" "Sid_RigRN.phl[280]";
connectAttr "RollHeel_R_translateZ.o" "Sid_RigRN.phl[281]";
connectAttr "RollHeel_R_visibility.o" "Sid_RigRN.phl[282]";
connectAttr "RollHeel_R_rotateX.o" "Sid_RigRN.phl[283]";
connectAttr "RollHeel_R_rotateY.o" "Sid_RigRN.phl[284]";
connectAttr "RollHeel_R_rotateZ.o" "Sid_RigRN.phl[285]";
connectAttr "RollHeel_R_scaleX.o" "Sid_RigRN.phl[286]";
connectAttr "RollHeel_R_scaleY.o" "Sid_RigRN.phl[287]";
connectAttr "RollHeel_R_scaleZ.o" "Sid_RigRN.phl[288]";
connectAttr "RollToesEnd_R_translateX.o" "Sid_RigRN.phl[289]";
connectAttr "RollToesEnd_R_translateY.o" "Sid_RigRN.phl[290]";
connectAttr "RollToesEnd_R_translateZ.o" "Sid_RigRN.phl[291]";
connectAttr "RollToesEnd_R_visibility.o" "Sid_RigRN.phl[292]";
connectAttr "RollToesEnd_R_rotateX.o" "Sid_RigRN.phl[293]";
connectAttr "RollToesEnd_R_rotateY.o" "Sid_RigRN.phl[294]";
connectAttr "RollToesEnd_R_rotateZ.o" "Sid_RigRN.phl[295]";
connectAttr "RollToesEnd_R_scaleX.o" "Sid_RigRN.phl[296]";
connectAttr "RollToesEnd_R_scaleY.o" "Sid_RigRN.phl[297]";
connectAttr "RollToesEnd_R_scaleZ.o" "Sid_RigRN.phl[298]";
connectAttr "RollToes_R_rotateZ.o" "Sid_RigRN.phl[299]";
connectAttr "RollToes_R_rotateX.o" "Sid_RigRN.phl[300]";
connectAttr "RollToes_R_rotateY.o" "Sid_RigRN.phl[301]";
connectAttr "RollToes_R_translateX.o" "Sid_RigRN.phl[302]";
connectAttr "RollToes_R_translateY.o" "Sid_RigRN.phl[303]";
connectAttr "RollToes_R_translateZ.o" "Sid_RigRN.phl[304]";
connectAttr "RollToes_R_visibility.o" "Sid_RigRN.phl[305]";
connectAttr "RollToes_R_scaleX.o" "Sid_RigRN.phl[306]";
connectAttr "RollToes_R_scaleY.o" "Sid_RigRN.phl[307]";
connectAttr "RollToes_R_scaleZ.o" "Sid_RigRN.phl[308]";
connectAttr "PoleLeg_R_translateX.o" "Sid_RigRN.phl[309]";
connectAttr "PoleLeg_R_translateY.o" "Sid_RigRN.phl[310]";
connectAttr "PoleLeg_R_translateZ.o" "Sid_RigRN.phl[311]";
connectAttr "PoleLeg_R_follow.o" "Sid_RigRN.phl[312]";
connectAttr "PoleLeg_R_lock.o" "Sid_RigRN.phl[313]";
connectAttr "IKLeg_L_translateX.o" "Sid_RigRN.phl[314]";
connectAttr "IKLeg_L_translateY.o" "Sid_RigRN.phl[315]";
connectAttr "IKLeg_L_translateZ.o" "Sid_RigRN.phl[316]";
connectAttr "IKLeg_L_rotateX.o" "Sid_RigRN.phl[317]";
connectAttr "IKLeg_L_rotateY.o" "Sid_RigRN.phl[318]";
connectAttr "IKLeg_L_rotateZ.o" "Sid_RigRN.phl[319]";
connectAttr "IKLeg_L_toe.o" "Sid_RigRN.phl[320]";
connectAttr "IKLeg_L_rollAngle.o" "Sid_RigRN.phl[321]";
connectAttr "IKLeg_L_roll.o" "Sid_RigRN.phl[322]";
connectAttr "IKLeg_L_stretchy.o" "Sid_RigRN.phl[323]";
connectAttr "IKLeg_L_antiPop.o" "Sid_RigRN.phl[324]";
connectAttr "IKLeg_L_Lenght1.o" "Sid_RigRN.phl[325]";
connectAttr "IKLeg_L_Lenght2.o" "Sid_RigRN.phl[326]";
connectAttr "IKLeg_L_volume.o" "Sid_RigRN.phl[327]";
connectAttr "RollHeel_L_translateX.o" "Sid_RigRN.phl[328]";
connectAttr "RollHeel_L_translateY.o" "Sid_RigRN.phl[329]";
connectAttr "RollHeel_L_translateZ.o" "Sid_RigRN.phl[330]";
connectAttr "RollHeel_L_visibility.o" "Sid_RigRN.phl[331]";
connectAttr "RollHeel_L_rotateX.o" "Sid_RigRN.phl[332]";
connectAttr "RollHeel_L_rotateY.o" "Sid_RigRN.phl[333]";
connectAttr "RollHeel_L_rotateZ.o" "Sid_RigRN.phl[334]";
connectAttr "RollHeel_L_scaleX.o" "Sid_RigRN.phl[335]";
connectAttr "RollHeel_L_scaleY.o" "Sid_RigRN.phl[336]";
connectAttr "RollHeel_L_scaleZ.o" "Sid_RigRN.phl[337]";
connectAttr "RollToesEnd_L_translateX.o" "Sid_RigRN.phl[338]";
connectAttr "RollToesEnd_L_translateY.o" "Sid_RigRN.phl[339]";
connectAttr "RollToesEnd_L_translateZ.o" "Sid_RigRN.phl[340]";
connectAttr "RollToesEnd_L_visibility.o" "Sid_RigRN.phl[341]";
connectAttr "RollToesEnd_L_rotateX.o" "Sid_RigRN.phl[342]";
connectAttr "RollToesEnd_L_rotateY.o" "Sid_RigRN.phl[343]";
connectAttr "RollToesEnd_L_rotateZ.o" "Sid_RigRN.phl[344]";
connectAttr "RollToesEnd_L_scaleX.o" "Sid_RigRN.phl[345]";
connectAttr "RollToesEnd_L_scaleY.o" "Sid_RigRN.phl[346]";
connectAttr "RollToesEnd_L_scaleZ.o" "Sid_RigRN.phl[347]";
connectAttr "RollToes_L_rotateZ.o" "Sid_RigRN.phl[348]";
connectAttr "RollToes_L_rotateX.o" "Sid_RigRN.phl[349]";
connectAttr "RollToes_L_rotateY.o" "Sid_RigRN.phl[350]";
connectAttr "RollToes_L_translateX.o" "Sid_RigRN.phl[351]";
connectAttr "RollToes_L_translateY.o" "Sid_RigRN.phl[352]";
connectAttr "RollToes_L_translateZ.o" "Sid_RigRN.phl[353]";
connectAttr "RollToes_L_visibility.o" "Sid_RigRN.phl[354]";
connectAttr "RollToes_L_scaleX.o" "Sid_RigRN.phl[355]";
connectAttr "RollToes_L_scaleY.o" "Sid_RigRN.phl[356]";
connectAttr "RollToes_L_scaleZ.o" "Sid_RigRN.phl[357]";
connectAttr "PoleLeg_L_translateX.o" "Sid_RigRN.phl[358]";
connectAttr "PoleLeg_L_translateY.o" "Sid_RigRN.phl[359]";
connectAttr "PoleLeg_L_translateZ.o" "Sid_RigRN.phl[360]";
connectAttr "PoleLeg_L_follow.o" "Sid_RigRN.phl[361]";
connectAttr "PoleLeg_L_lock.o" "Sid_RigRN.phl[362]";
connectAttr "FKIKLeg_R_FKIKBlend.o" "Sid_RigRN.phl[363]";
connectAttr "FKIKLeg_R_IKVis.o" "Sid_RigRN.phl[364]";
connectAttr "FKIKLeg_R_FKVis.o" "Sid_RigRN.phl[365]";
connectAttr "FKIKArm_R_FKIKBlend.o" "Sid_RigRN.phl[366]";
connectAttr "FKIKArm_R_IKVis.o" "Sid_RigRN.phl[367]";
connectAttr "FKIKArm_R_FKVis.o" "Sid_RigRN.phl[368]";
connectAttr "FKIKSpine_M_IKVis.o" "Sid_RigRN.phl[369]";
connectAttr "FKIKSpine_M_FKVis.o" "Sid_RigRN.phl[370]";
connectAttr "FKIKLeg_L_FKIKBlend.o" "Sid_RigRN.phl[371]";
connectAttr "FKIKLeg_L_IKVis.o" "Sid_RigRN.phl[372]";
connectAttr "FKIKLeg_L_FKVis.o" "Sid_RigRN.phl[373]";
connectAttr "FKIKArm_L_FKIKBlend.o" "Sid_RigRN.phl[374]";
connectAttr "FKIKArm_L_IKVis.o" "Sid_RigRN.phl[375]";
connectAttr "FKIKArm_L_FKVis.o" "Sid_RigRN.phl[376]";
connectAttr "RootX_M_rotateX.o" "Sid_RigRN.phl[377]";
connectAttr "RootX_M_rotateY.o" "Sid_RigRN.phl[378]";
connectAttr "RootX_M_rotateZ.o" "Sid_RigRN.phl[379]";
connectAttr "RootX_M_legLock.o" "Sid_RigRN.phl[380]";
connectAttr "RootX_M_CenterBtwFeet.o" "Sid_RigRN.phl[381]";
connectAttr "RootX_M_translateX.o" "Sid_RigRN.phl[382]";
connectAttr "RootX_M_translateY.o" "Sid_RigRN.phl[383]";
connectAttr "RootX_M_translateZ.o" "Sid_RigRN.phl[384]";
connectAttr "Fingers_L_indexCurl.o" "Sid_RigRN.phl[385]";
connectAttr "Fingers_L_middleCurl.o" "Sid_RigRN.phl[386]";
connectAttr "Fingers_L_pinkyCurl.o" "Sid_RigRN.phl[387]";
connectAttr "Fingers_L_thumbCurl.o" "Sid_RigRN.phl[388]";
connectAttr "Fingers_L_spread.o" "Sid_RigRN.phl[389]";
connectAttr "Sid_RigRN.phl[390]" "shotCam_parentConstraint1.tg[0].tt";
connectAttr "Sid_RigRN.phl[391]" "shotCam_parentConstraint1.tg[0].trp";
connectAttr "Sid_RigRN.phl[392]" "shotCam_parentConstraint1.tg[0].trt";
connectAttr "Sid_RigRN.phl[393]" "shotCam_parentConstraint1.tg[0].tr";
connectAttr "Sid_RigRN.phl[394]" "shotCam_parentConstraint1.tg[0].tro";
connectAttr "Sid_RigRN.phl[395]" "shotCam_parentConstraint1.tg[0].ts";
connectAttr "Sid_RigRN.phl[396]" "shotCam_parentConstraint1.tg[0].tpm";
connectAttr "shotCam_parentConstraint1.ctx" "shotCam.tx" -l on;
connectAttr "shotCam_parentConstraint1.cty" "shotCam.ty" -l on;
connectAttr "shotCam_parentConstraint1.ctz" "shotCam.tz" -l on;
connectAttr "shotCam_parentConstraint1.crx" "shotCam.rx" -l on;
connectAttr "shotCam_parentConstraint1.cry" "shotCam.ry" -l on;
connectAttr "shotCam_parentConstraint1.crz" "shotCam.rz" -l on;
connectAttr "shotCam.ro" "shotCam_parentConstraint1.cro";
connectAttr "shotCam.pim" "shotCam_parentConstraint1.cpim";
connectAttr "shotCam.rp" "shotCam_parentConstraint1.crp";
connectAttr "shotCam.rpt" "shotCam_parentConstraint1.crt";
connectAttr "shotCam_parentConstraint1.w0" "shotCam_parentConstraint1.tg[0].tw";
connectAttr "polyDisc1.output" "pDiscShape1.i";
connectAttr "place3dTexture1_translateX.o" "place3dTexture1.tx";
connectAttr "place3dTexture1_translateY.o" "place3dTexture1.ty";
connectAttr "place3dTexture1_translateZ.o" "place3dTexture1.tz";
connectAttr "place3dTexture1_visibility.o" "place3dTexture1.v";
connectAttr "place3dTexture1_rotateX.o" "place3dTexture1.rx";
connectAttr "place3dTexture1_rotateY.o" "place3dTexture1.ry";
connectAttr "place3dTexture1_rotateZ.o" "place3dTexture1.rz";
connectAttr "place3dTexture1_scaleX.o" "place3dTexture1.sx";
connectAttr "place3dTexture1_scaleY.o" "place3dTexture1.sy";
connectAttr "place3dTexture1_scaleZ.o" "place3dTexture1.sz";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" "lambert2SG.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" "lambert2SG.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "sharedReferenceNode.sr" "Sid_RigRN.sr";
connectAttr "pairBlend1_inTranslateX1.o" "pairBlend1.itx1";
connectAttr "pairBlend1_inTranslateY1.o" "pairBlend1.ity1";
connectAttr "pairBlend1_inTranslateZ1.o" "pairBlend1.itz1";
connectAttr "pairBlend1_inRotateX1.o" "pairBlend1.irx1";
connectAttr "pairBlend1_inRotateY1.o" "pairBlend1.iry1";
connectAttr "pairBlend1_inRotateZ1.o" "pairBlend1.irz1";
connectAttr "projection1.oc" "lambert2.c";
connectAttr "lambert2.oc" "lambert2SG.ss";
connectAttr "pDiscShape1.iog" "lambert2SG.dsm" -na;
connectAttr "lambert2SG.msg" "materialInfo1.sg";
connectAttr "lambert2.msg" "materialInfo1.m";
connectAttr "projection1.msg" "materialInfo1.t" -na;
connectAttr "place3dTexture1.wim" "projection1.pm";
connectAttr "checker1.oc" "projection1.im";
connectAttr "place2dTexture1.o" "checker1.uv";
connectAttr "place2dTexture1.ofs" "checker1.fs";
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
connectAttr "lambert2SG.pa" ":renderPartition.st" -na;
connectAttr "lambert2.msg" ":defaultShaderList1.s" -na;
connectAttr "place3dTexture1.msg" ":defaultRenderUtilityList1.u" -na;
connectAttr "place2dTexture1.msg" ":defaultRenderUtilityList1.u" -na;
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
connectAttr "projection1.msg" ":defaultTextureList1.tx" -na;
connectAttr "checker1.msg" ":defaultTextureList1.tx" -na;
// End of Sid_SkateLoop.ma
