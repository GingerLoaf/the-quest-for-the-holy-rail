//Maya ASCII 2023 scene
//Name: Sid_Grind_A.ma
//Last modified: Tue, Jan 27, 2026 09:01:04 AM
//Codeset: 1252
file -rdi 1 -ns "Sid_Rig" -rfn "Sid_RigRN" -op "v=0;" -typ "mayaAscii" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Sid_Rig.ma";
file -r -ns "Sid_Rig" -dr 1 -rfn "Sid_RigRN" -op "v=0;" -typ "mayaAscii" "E:/Dev/GGJ26_QuestForHolyRail/the-quest-for-the-holy-rail/SourceArt/Sid/Sid_Rig.ma";
requires maya "2023";
requires -nodeType "polyDisc" "modelingToolkit" "0.0.0.0";
requires "stereoCamera" "10.0";
requires "mtoa" "5.1.0";
requires -nodeType "ilrOptionsNode" -nodeType "ilrUIOptionsNode" -nodeType "ilrBakeLayerManager"
		 -nodeType "ilrBakeLayer" "Turtle" "2023.0.0";
requires "maxwell" "1.0.16";
requires "stereoCamera" "10.0";
currentUnit -l centimeter -a degree -t film;
fileInfo "application" "maya";
fileInfo "product" "Maya 2023";
fileInfo "version" "2023";
fileInfo "cutIdentifier" "202202161415-df43006fd3";
fileInfo "osv" "Windows 11 Pro v2009 (Build: 26200)";
fileInfo "UUID" "6761BC61-4450-EE75-1299-30A90A352D76";
createNode transform -s -n "persp";
	rename -uid "F495849A-4EF3-5842-1102-12A1D910B708";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 85.087580875751428 61.145768613841057 -200.61727688420416 ;
	setAttr ".r" -type "double3" -13.538352729332759 876.19999999972549 0 ;
createNode camera -s -n "perspShape" -p "persp";
	rename -uid "3868E77A-4068-298E-E60D-E08DBDCF4BD5";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".coi" 222.72746183949894;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	rename -uid "9C5D80E2-4058-E7AE-E687-06A5C9F01F07";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 1000.1 0 ;
	setAttr ".r" -type "double3" -90 0 0 ;
createNode camera -s -n "topShape" -p "top";
	rename -uid "F1CAE679-4948-B4C0-6898-FF87C93271AA";
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
	rename -uid "3554D14F-43BA-9D84-7FB3-04AADA938156";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 0 1000.1 ;
createNode camera -s -n "frontShape" -p "front";
	rename -uid "63C7F2AA-41A1-A572-295F-C99570773328";
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
	rename -uid "B827B2D1-4C76-1F83-0875-12BCA54DB977";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 1000.1 0 0 ;
	setAttr ".r" -type "double3" 0 90 0 ;
createNode camera -s -n "sideShape" -p "side";
	rename -uid "EEC34AF9-4412-1D16-2459-5887853E3346";
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
createNode transform -n "pDisc1";
	rename -uid "1F46EC6C-4EBE-76FD-132C-219D5BB72082";
	setAttr ".v" no;
	setAttr ".s" -type "double3" 276.72469990200966 276.72469990200966 276.72469990200966 ;
createNode mesh -n "pDiscShape1" -p "pDisc1";
	rename -uid "41EE5618-495E-7812-4122-4D8DE40D55A3";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
createNode place3dTexture -n "place3dTexture1";
	rename -uid "025AC943-4FEC-2CB4-E55C-2B88375ED5E7";
	setAttr ".r" -type "double3" 90.000000000000028 0 0 ;
	setAttr ".s" -type "double3" 48.466666699365852 48.466666699365852 48.466666699365852 ;
createNode transform -n "pCube1";
	rename -uid "71F79EE9-4FF4-1106-1072-ACA1262A489F";
	setAttr ".t" -type "double3" -0.61242773553789887 -1.9677883870363528 0 ;
	setAttr ".s" -type "double3" 1 3.0442564325474528 535.21819832703147 ;
createNode mesh -n "pCubeShape1" -p "pCube1";
	rename -uid "F47E4A97-405B-931E-FBAA-7E9075479ED9";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
createNode lightLinker -s -n "lightLinker1";
	rename -uid "62873928-42D4-2472-3B95-CC87DB59953F";
	setAttr -s 24 ".lnk";
	setAttr -s 24 ".slnk";
createNode shapeEditorManager -n "shapeEditorManager";
	rename -uid "3F25FB9F-4195-88D5-9250-D3A0338F062D";
createNode poseInterpolatorManager -n "poseInterpolatorManager";
	rename -uid "DC1712DF-405C-703D-33E6-B783D2E6E28C";
createNode displayLayerManager -n "layerManager";
	rename -uid "E8F03749-4D57-8E7B-D5FF-B897C99FC789";
createNode displayLayer -n "defaultLayer";
	rename -uid "F56868AC-4B00-185F-AFF5-A6939512FC0E";
createNode renderLayerManager -n "renderLayerManager";
	rename -uid "61FC2318-4A34-97E7-885E-DF9535F303BD";
createNode renderLayer -n "defaultRenderLayer";
	rename -uid "998E9117-4E20-0363-8652-C09BF5FC2964";
	setAttr ".g" yes;
createNode reference -n "Sid_RigRN";
	rename -uid "1D97838A-49FE-5430-D2B9-72A8BAE92104";
	setAttr -s 380 ".phl";
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
	setAttr ".ed" -type "dataReferenceEdits" 
		"Sid_RigRN"
		"Sid_RigRN" 0
		"Sid_RigRN" 406
		1 |Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master "blendParent1" "blendParent1" 
		" -ci 1 -k 1 -dv 1 -smn 0 -smx 1 -at \"double\""
		2 "|Sid_Rig:Collar_Grp|Sid_Rig:Collar_Ctrl_Master" "blendParent1" " -k 1"
		
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
		2 "Sid_Rig:Mesh" "hideOnPlayback" " 0"
		2 "Sid_Rig:Ctrls" "hideOnPlayback" " 0"
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
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateX" 
		"Sid_RigRN.placeHolderList[31]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateY" 
		"Sid_RigRN.placeHolderList[32]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M.rotateZ" 
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
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateX" 
		"Sid_RigRN.placeHolderList[57]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateY" 
		"Sid_RigRN.placeHolderList[58]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetHead_M|Sid_Rig:FKGlobalStaticHead_M|Sid_Rig:FKGlobalHead_M|Sid_Rig:FKExtraHead_M|Sid_Rig:FKHead_M|Sid_Rig:Gorro_Ctrl.rotateZ" 
		"Sid_RigRN.placeHolderList[59]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateX" 
		"Sid_RigRN.placeHolderList[60]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateY" 
		"Sid_RigRN.placeHolderList[61]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R.rotateZ" 
		"Sid_RigRN.placeHolderList[62]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateX" 
		"Sid_RigRN.placeHolderList[63]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateX" 
		"Sid_RigRN.placeHolderList[64]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateY" 
		"Sid_RigRN.placeHolderList[65]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateY" 
		"Sid_RigRN.placeHolderList[66]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[67]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[68]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[69]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateX" 
		"Sid_RigRN.placeHolderList[70]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateX" 
		"Sid_RigRN.placeHolderList[71]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateY" 
		"Sid_RigRN.placeHolderList[72]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateY" 
		"Sid_RigRN.placeHolderList[73]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateZ" 
		"Sid_RigRN.placeHolderList[74]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateZ" 
		"Sid_RigRN.placeHolderList[75]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[76]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateX" 
		"Sid_RigRN.placeHolderList[77]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateX" 
		"Sid_RigRN.placeHolderList[78]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateY" 
		"Sid_RigRN.placeHolderList[79]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateY" 
		"Sid_RigRN.placeHolderList[80]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[81]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[82]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[83]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateX" 
		"Sid_RigRN.placeHolderList[84]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateX" 
		"Sid_RigRN.placeHolderList[85]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateY" 
		"Sid_RigRN.placeHolderList[86]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateY" 
		"Sid_RigRN.placeHolderList[87]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateZ" 
		"Sid_RigRN.placeHolderList[88]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateZ" 
		"Sid_RigRN.placeHolderList[89]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_R|Sid_Rig:FKExtraShoulder_R|Sid_Rig:FKShoulder_R|Sid_Rig:FKXShoulder_R|Sid_Rig:FKOffsetShoulder1_R|Sid_Rig:FKExtraShoulder1_R|Sid_Rig:FKShoulder1_R|Sid_Rig:FKXShoulder1_R|Sid_Rig:FKOffsetElbow_R|Sid_Rig:FKExtraElbow_R|Sid_Rig:FKElbow_R|Sid_Rig:FKXElbow_R|Sid_Rig:FKOffsetElbow1_R|Sid_Rig:FKExtraElbow1_R|Sid_Rig:FKElbow1_R|Sid_Rig:FKXElbow1_R|Sid_Rig:FKOffsetWrist_R|Sid_Rig:FKExtraWrist_R|Sid_Rig:FKWrist_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[90]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateX" 
		"Sid_RigRN.placeHolderList[91]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateY" 
		"Sid_RigRN.placeHolderList[92]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L.rotateZ" 
		"Sid_RigRN.placeHolderList[93]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateX" 
		"Sid_RigRN.placeHolderList[94]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateX" 
		"Sid_RigRN.placeHolderList[95]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateY" 
		"Sid_RigRN.placeHolderList[96]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateY" 
		"Sid_RigRN.placeHolderList[97]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[98]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[99]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[100]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateX" 
		"Sid_RigRN.placeHolderList[101]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateX" 
		"Sid_RigRN.placeHolderList[102]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateY" 
		"Sid_RigRN.placeHolderList[103]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateY" 
		"Sid_RigRN.placeHolderList[104]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateZ" 
		"Sid_RigRN.placeHolderList[105]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateZ" 
		"Sid_RigRN.placeHolderList[106]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[107]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateX" 
		"Sid_RigRN.placeHolderList[108]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateX" 
		"Sid_RigRN.placeHolderList[109]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateY" 
		"Sid_RigRN.placeHolderList[110]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateY" 
		"Sid_RigRN.placeHolderList[111]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[112]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[113]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[114]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateX" 
		"Sid_RigRN.placeHolderList[115]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateX" 
		"Sid_RigRN.placeHolderList[116]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateY" 
		"Sid_RigRN.placeHolderList[117]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateY" 
		"Sid_RigRN.placeHolderList[118]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateZ" 
		"Sid_RigRN.placeHolderList[119]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateZ" 
		"Sid_RigRN.placeHolderList[120]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToChest_M|Sid_Rig:FKOffsetShoulder_L|Sid_Rig:FKExtraShoulder_L|Sid_Rig:FKShoulder_L|Sid_Rig:FKXShoulder_L|Sid_Rig:FKOffsetShoulder1_L|Sid_Rig:FKExtraShoulder1_L|Sid_Rig:FKShoulder1_L|Sid_Rig:FKXShoulder1_L|Sid_Rig:FKOffsetElbow_L|Sid_Rig:FKExtraElbow_L|Sid_Rig:FKElbow_L|Sid_Rig:FKXElbow_L|Sid_Rig:FKOffsetElbow1_L|Sid_Rig:FKExtraElbow1_L|Sid_Rig:FKElbow1_L|Sid_Rig:FKXElbow1_L|Sid_Rig:FKOffsetWrist_L|Sid_Rig:FKExtraWrist_L|Sid_Rig:FKWrist_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[121]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[122]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[123]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[124]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[125]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[126]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[127]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[128]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[129]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetMiddleFinger1_R|Sid_Rig:SDK1FKMiddleFinger1_R|Sid_Rig:FKExtraMiddleFinger1_R|Sid_Rig:FKMiddleFinger1_R|Sid_Rig:FKXMiddleFinger1_R|Sid_Rig:FKOffsetMiddleFinger2_R|Sid_Rig:SDK1FKMiddleFinger2_R|Sid_Rig:FKExtraMiddleFinger2_R|Sid_Rig:FKMiddleFinger2_R|Sid_Rig:FKXMiddleFinger2_R|Sid_Rig:FKOffsetMiddleFinger3_R|Sid_Rig:SDK1FKMiddleFinger3_R|Sid_Rig:FKExtraMiddleFinger3_R|Sid_Rig:FKMiddleFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[130]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[131]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[132]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[133]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[134]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[135]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[136]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[137]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[138]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetThumbFinger1_R|Sid_Rig:FKExtraThumbFinger1_R|Sid_Rig:FKThumbFinger1_R|Sid_Rig:FKXThumbFinger1_R|Sid_Rig:FKOffsetThumbFinger2_R|Sid_Rig:SDK1FKThumbFinger2_R|Sid_Rig:FKExtraThumbFinger2_R|Sid_Rig:FKThumbFinger2_R|Sid_Rig:FKXThumbFinger2_R|Sid_Rig:FKOffsetThumbFinger3_R|Sid_Rig:SDK1FKThumbFinger3_R|Sid_Rig:FKExtraThumbFinger3_R|Sid_Rig:FKThumbFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[139]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[140]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[141]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[142]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[143]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[144]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[145]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[146]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[147]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetIndexFinger1_R|Sid_Rig:SDK1FKIndexFinger1_R|Sid_Rig:SDK2FKIndexFinger1_R|Sid_Rig:FKExtraIndexFinger1_R|Sid_Rig:FKIndexFinger1_R|Sid_Rig:FKXIndexFinger1_R|Sid_Rig:FKOffsetIndexFinger2_R|Sid_Rig:SDK1FKIndexFinger2_R|Sid_Rig:FKExtraIndexFinger2_R|Sid_Rig:FKIndexFinger2_R|Sid_Rig:FKXIndexFinger2_R|Sid_Rig:FKOffsetIndexFinger3_R|Sid_Rig:SDK1FKIndexFinger3_R|Sid_Rig:FKExtraIndexFinger3_R|Sid_Rig:FKIndexFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[148]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateX" 
		"Sid_RigRN.placeHolderList[149]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateY" 
		"Sid_RigRN.placeHolderList[150]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R.rotateZ" 
		"Sid_RigRN.placeHolderList[151]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateX" 
		"Sid_RigRN.placeHolderList[152]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateY" 
		"Sid_RigRN.placeHolderList[153]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R.rotateZ" 
		"Sid_RigRN.placeHolderList[154]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateX" 
		"Sid_RigRN.placeHolderList[155]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateY" 
		"Sid_RigRN.placeHolderList[156]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_R|Sid_Rig:FKOffsetPinkyFinger1_R|Sid_Rig:SDK1FKPinkyFinger1_R|Sid_Rig:SDK2FKPinkyFinger1_R|Sid_Rig:FKExtraPinkyFinger1_R|Sid_Rig:FKPinkyFinger1_R|Sid_Rig:FKXPinkyFinger1_R|Sid_Rig:FKOffsetPinkyFinger2_R|Sid_Rig:SDK1FKPinkyFinger2_R|Sid_Rig:FKExtraPinkyFinger2_R|Sid_Rig:FKPinkyFinger2_R|Sid_Rig:FKXPinkyFinger2_R|Sid_Rig:FKOffsetPinkyFinger3_R|Sid_Rig:SDK1FKPinkyFinger3_R|Sid_Rig:FKExtraPinkyFinger3_R|Sid_Rig:FKPinkyFinger3_R.rotateZ" 
		"Sid_RigRN.placeHolderList[157]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.uiTreatment" 
		"Sid_RigRN.placeHolderList[158]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateX" 
		"Sid_RigRN.placeHolderList[159]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateY" 
		"Sid_RigRN.placeHolderList[160]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.translateZ" 
		"Sid_RigRN.placeHolderList[161]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateX" 
		"Sid_RigRN.placeHolderList[162]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateY" 
		"Sid_RigRN.placeHolderList[163]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKSpine1_M.rotateZ" 
		"Sid_RigRN.placeHolderList[164]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateX" 
		"Sid_RigRN.placeHolderList[165]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateY" 
		"Sid_RigRN.placeHolderList[166]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.translateZ" 
		"Sid_RigRN.placeHolderList[167]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateX" 
		"Sid_RigRN.placeHolderList[168]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateY" 
		"Sid_RigRN.placeHolderList[169]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:FKXRoot_M|Sid_Rig:FKOffsetRootPart1_M|Sid_Rig:FKExtraRootPart1_M|Sid_Rig:FKRootPart1_M|Sid_Rig:FKXRootPart1_M|Sid_Rig:FKOffsetRootPart2_M|Sid_Rig:FKExtraRootPart2_M|Sid_Rig:FKRootPart2_M|Sid_Rig:FKXRootPart2_M|Sid_Rig:FKOffsetSpine1_M|Sid_Rig:FKExtraSpine1_M|Sid_Rig:FKXSpine1_M|Sid_Rig:FKOffsetSpine1Part1_M|Sid_Rig:FKExtraSpine1Part1_M|Sid_Rig:FKSpine1Part1_M|Sid_Rig:FKXSpine1Part1_M|Sid_Rig:FKOffsetSpine1Part2_M|Sid_Rig:FKExtraSpine1Part2_M|Sid_Rig:FKSpine1Part2_M|Sid_Rig:FKXSpine1Part2_M|Sid_Rig:FKOffsetChest_M|Sid_Rig:FKExtraChest_M|Sid_Rig:FKChest_M.rotateZ" 
		"Sid_RigRN.placeHolderList[170]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.translateX" 
		"Sid_RigRN.placeHolderList[171]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.translateY" 
		"Sid_RigRN.placeHolderList[172]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.translateZ" 
		"Sid_RigRN.placeHolderList[173]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateX" 
		"Sid_RigRN.placeHolderList[174]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateY" 
		"Sid_RigRN.placeHolderList[175]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKOffsetRoot_M|Sid_Rig:FKExtraRoot_M|Sid_Rig:HipSwingerStabilizer|Sid_Rig:FKRoot_M.rotateZ" 
		"Sid_RigRN.placeHolderList[176]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateX" 
		"Sid_RigRN.placeHolderList[177]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateY" 
		"Sid_RigRN.placeHolderList[178]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToAnkle_L|Sid_Rig:FKOffsetToes_L|Sid_Rig:FKFootRollIKToes_L|Sid_Rig:FKExtraToes_L|Sid_Rig:FKToes_L.rotateZ" 
		"Sid_RigRN.placeHolderList[179]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[180]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[181]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[182]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[183]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[184]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[185]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[186]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[187]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetMiddleFinger1_L|Sid_Rig:SDK1FKMiddleFinger1_L|Sid_Rig:FKExtraMiddleFinger1_L|Sid_Rig:FKMiddleFinger1_L|Sid_Rig:FKXMiddleFinger1_L|Sid_Rig:FKOffsetMiddleFinger2_L|Sid_Rig:SDK1FKMiddleFinger2_L|Sid_Rig:FKExtraMiddleFinger2_L|Sid_Rig:FKMiddleFinger2_L|Sid_Rig:FKXMiddleFinger2_L|Sid_Rig:FKOffsetMiddleFinger3_L|Sid_Rig:SDK1FKMiddleFinger3_L|Sid_Rig:FKExtraMiddleFinger3_L|Sid_Rig:FKMiddleFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[188]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[189]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[190]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[191]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[192]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[193]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[194]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[195]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[196]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetThumbFinger1_L|Sid_Rig:FKExtraThumbFinger1_L|Sid_Rig:FKThumbFinger1_L|Sid_Rig:FKXThumbFinger1_L|Sid_Rig:FKOffsetThumbFinger2_L|Sid_Rig:SDK1FKThumbFinger2_L|Sid_Rig:FKExtraThumbFinger2_L|Sid_Rig:FKThumbFinger2_L|Sid_Rig:FKXThumbFinger2_L|Sid_Rig:FKOffsetThumbFinger3_L|Sid_Rig:SDK1FKThumbFinger3_L|Sid_Rig:FKExtraThumbFinger3_L|Sid_Rig:FKThumbFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[197]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[198]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[199]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[200]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[201]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[202]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[203]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[204]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[205]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetIndexFinger1_L|Sid_Rig:SDK1FKIndexFinger1_L|Sid_Rig:SDK2FKIndexFinger1_L|Sid_Rig:FKExtraIndexFinger1_L|Sid_Rig:FKIndexFinger1_L|Sid_Rig:FKXIndexFinger1_L|Sid_Rig:FKOffsetIndexFinger2_L|Sid_Rig:SDK1FKIndexFinger2_L|Sid_Rig:FKExtraIndexFinger2_L|Sid_Rig:FKIndexFinger2_L|Sid_Rig:FKXIndexFinger2_L|Sid_Rig:FKOffsetIndexFinger3_L|Sid_Rig:SDK1FKIndexFinger3_L|Sid_Rig:FKExtraIndexFinger3_L|Sid_Rig:FKIndexFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[206]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateX" 
		"Sid_RigRN.placeHolderList[207]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateY" 
		"Sid_RigRN.placeHolderList[208]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L.rotateZ" 
		"Sid_RigRN.placeHolderList[209]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateX" 
		"Sid_RigRN.placeHolderList[210]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateY" 
		"Sid_RigRN.placeHolderList[211]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L.rotateZ" 
		"Sid_RigRN.placeHolderList[212]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateX" 
		"Sid_RigRN.placeHolderList[213]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateY" 
		"Sid_RigRN.placeHolderList[214]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:FKParentConstraintToWrist_L|Sid_Rig:FKOffsetPinkyFinger1_L|Sid_Rig:SDK1FKPinkyFinger1_L|Sid_Rig:SDK2FKPinkyFinger1_L|Sid_Rig:FKExtraPinkyFinger1_L|Sid_Rig:FKPinkyFinger1_L|Sid_Rig:FKXPinkyFinger1_L|Sid_Rig:FKOffsetPinkyFinger2_L|Sid_Rig:SDK1FKPinkyFinger2_L|Sid_Rig:FKExtraPinkyFinger2_L|Sid_Rig:FKPinkyFinger2_L|Sid_Rig:FKXPinkyFinger2_L|Sid_Rig:FKOffsetPinkyFinger3_L|Sid_Rig:SDK1FKPinkyFinger3_L|Sid_Rig:FKExtraPinkyFinger3_L|Sid_Rig:FKPinkyFinger3_L.rotateZ" 
		"Sid_RigRN.placeHolderList[215]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateX" 
		"Sid_RigRN.placeHolderList[216]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateY" 
		"Sid_RigRN.placeHolderList[217]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.rotateZ" 
		"Sid_RigRN.placeHolderList[218]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKSystem|Sid_Rig:HipSwingerOffset_M|Sid_Rig:HipSwinger_M.stabilize" 
		"Sid_RigRN.placeHolderList[219]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateZ" 
		"Sid_RigRN.placeHolderList[220]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateZ" 
		"Sid_RigRN.placeHolderList[221]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateX" 
		"Sid_RigRN.placeHolderList[222]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateX" 
		"Sid_RigRN.placeHolderList[223]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateY" 
		"Sid_RigRN.placeHolderList[224]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.translateY" 
		"Sid_RigRN.placeHolderList[225]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateY" 
		"Sid_RigRN.placeHolderList[226]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateY" 
		"Sid_RigRN.placeHolderList[227]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateX" 
		"Sid_RigRN.placeHolderList[228]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateX" 
		"Sid_RigRN.placeHolderList[229]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateZ" 
		"Sid_RigRN.placeHolderList[230]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateZ" 
		"Sid_RigRN.placeHolderList[231]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rotateOrder" 
		"Sid_RigRN.placeHolderList[232]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.toe" 
		"Sid_RigRN.placeHolderList[233]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.toe" 
		"Sid_RigRN.placeHolderList[234]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rollAngle" 
		"Sid_RigRN.placeHolderList[235]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.rollAngle" 
		"Sid_RigRN.placeHolderList[236]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.roll" 
		"Sid_RigRN.placeHolderList[237]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.roll" 
		"Sid_RigRN.placeHolderList[238]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.stretchy" 
		"Sid_RigRN.placeHolderList[239]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.stretchy" 
		"Sid_RigRN.placeHolderList[240]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.antiPop" 
		"Sid_RigRN.placeHolderList[241]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.antiPop" 
		"Sid_RigRN.placeHolderList[242]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght1" 
		"Sid_RigRN.placeHolderList[243]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght1" 
		"Sid_RigRN.placeHolderList[244]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght2" 
		"Sid_RigRN.placeHolderList[245]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.Lenght2" 
		"Sid_RigRN.placeHolderList[246]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.volume" 
		"Sid_RigRN.placeHolderList[247]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R.volume" 
		"Sid_RigRN.placeHolderList[248]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateX" 
		"Sid_RigRN.placeHolderList[249]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateY" 
		"Sid_RigRN.placeHolderList[250]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.translateZ" 
		"Sid_RigRN.placeHolderList[251]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.visibility" 
		"Sid_RigRN.placeHolderList[252]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateX" 
		"Sid_RigRN.placeHolderList[253]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateY" 
		"Sid_RigRN.placeHolderList[254]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.rotateZ" 
		"Sid_RigRN.placeHolderList[255]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleX" 
		"Sid_RigRN.placeHolderList[256]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleY" 
		"Sid_RigRN.placeHolderList[257]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R.scaleZ" 
		"Sid_RigRN.placeHolderList[258]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateX" 
		"Sid_RigRN.placeHolderList[259]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateY" 
		"Sid_RigRN.placeHolderList[260]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.translateZ" 
		"Sid_RigRN.placeHolderList[261]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.visibility" 
		"Sid_RigRN.placeHolderList[262]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateX" 
		"Sid_RigRN.placeHolderList[263]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateY" 
		"Sid_RigRN.placeHolderList[264]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.rotateZ" 
		"Sid_RigRN.placeHolderList[265]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleX" 
		"Sid_RigRN.placeHolderList[266]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleY" 
		"Sid_RigRN.placeHolderList[267]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R.scaleZ" 
		"Sid_RigRN.placeHolderList[268]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateZ" 
		"Sid_RigRN.placeHolderList[269]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateX" 
		"Sid_RigRN.placeHolderList[270]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.rotateY" 
		"Sid_RigRN.placeHolderList[271]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateX" 
		"Sid_RigRN.placeHolderList[272]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateY" 
		"Sid_RigRN.placeHolderList[273]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.translateZ" 
		"Sid_RigRN.placeHolderList[274]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.visibility" 
		"Sid_RigRN.placeHolderList[275]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleX" 
		"Sid_RigRN.placeHolderList[276]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleY" 
		"Sid_RigRN.placeHolderList[277]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_R|Sid_Rig:IKExtraLeg_R|Sid_Rig:IKLeg_R|Sid_Rig:IKLegFootRockInnerPivot_R|Sid_Rig:IKLegFootRockOuterPivot_R|Sid_Rig:RollOffsetHeel_R|Sid_Rig:RollExtraHeel_R|Sid_Rig:RollHeel_R|Sid_Rig:RollOffsetToesEnd_R|Sid_Rig:RollExtraToesEnd_R|Sid_Rig:RollToesEnd_R|Sid_Rig:RollOffsetToes_R|Sid_Rig:RollExtraToes_R|Sid_Rig:RollToes_R.scaleZ" 
		"Sid_RigRN.placeHolderList[278]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateX" 
		"Sid_RigRN.placeHolderList[279]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateY" 
		"Sid_RigRN.placeHolderList[280]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.translateZ" 
		"Sid_RigRN.placeHolderList[281]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.follow" 
		"Sid_RigRN.placeHolderList[282]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_R|Sid_Rig:PoleExtraLeg_R|Sid_Rig:PoleLeg_R.lock" 
		"Sid_RigRN.placeHolderList[283]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateX" 
		"Sid_RigRN.placeHolderList[284]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateX" 
		"Sid_RigRN.placeHolderList[285]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateY" 
		"Sid_RigRN.placeHolderList[286]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateY" 
		"Sid_RigRN.placeHolderList[287]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateZ" 
		"Sid_RigRN.placeHolderList[288]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.translateZ" 
		"Sid_RigRN.placeHolderList[289]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateY" 
		"Sid_RigRN.placeHolderList[290]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateY" 
		"Sid_RigRN.placeHolderList[291]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateX" 
		"Sid_RigRN.placeHolderList[292]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateX" 
		"Sid_RigRN.placeHolderList[293]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateZ" 
		"Sid_RigRN.placeHolderList[294]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateZ" 
		"Sid_RigRN.placeHolderList[295]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rotateOrder" 
		"Sid_RigRN.placeHolderList[296]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.toe" 
		"Sid_RigRN.placeHolderList[297]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.toe" 
		"Sid_RigRN.placeHolderList[298]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rollAngle" 
		"Sid_RigRN.placeHolderList[299]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.rollAngle" 
		"Sid_RigRN.placeHolderList[300]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.roll" 
		"Sid_RigRN.placeHolderList[301]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.roll" 
		"Sid_RigRN.placeHolderList[302]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.stretchy" 
		"Sid_RigRN.placeHolderList[303]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.stretchy" 
		"Sid_RigRN.placeHolderList[304]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.antiPop" 
		"Sid_RigRN.placeHolderList[305]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.antiPop" 
		"Sid_RigRN.placeHolderList[306]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght1" 
		"Sid_RigRN.placeHolderList[307]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght1" 
		"Sid_RigRN.placeHolderList[308]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght2" 
		"Sid_RigRN.placeHolderList[309]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.Lenght2" 
		"Sid_RigRN.placeHolderList[310]" ""
		5 3 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.volume" 
		"Sid_RigRN.placeHolderList[311]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L.volume" 
		"Sid_RigRN.placeHolderList[312]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateX" 
		"Sid_RigRN.placeHolderList[313]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateY" 
		"Sid_RigRN.placeHolderList[314]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.translateZ" 
		"Sid_RigRN.placeHolderList[315]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.visibility" 
		"Sid_RigRN.placeHolderList[316]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateX" 
		"Sid_RigRN.placeHolderList[317]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateY" 
		"Sid_RigRN.placeHolderList[318]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.rotateZ" 
		"Sid_RigRN.placeHolderList[319]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleX" 
		"Sid_RigRN.placeHolderList[320]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleY" 
		"Sid_RigRN.placeHolderList[321]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L.scaleZ" 
		"Sid_RigRN.placeHolderList[322]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateX" 
		"Sid_RigRN.placeHolderList[323]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateY" 
		"Sid_RigRN.placeHolderList[324]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.translateZ" 
		"Sid_RigRN.placeHolderList[325]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.visibility" 
		"Sid_RigRN.placeHolderList[326]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateX" 
		"Sid_RigRN.placeHolderList[327]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateY" 
		"Sid_RigRN.placeHolderList[328]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.rotateZ" 
		"Sid_RigRN.placeHolderList[329]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleX" 
		"Sid_RigRN.placeHolderList[330]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleY" 
		"Sid_RigRN.placeHolderList[331]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L.scaleZ" 
		"Sid_RigRN.placeHolderList[332]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateZ" 
		"Sid_RigRN.placeHolderList[333]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateX" 
		"Sid_RigRN.placeHolderList[334]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.rotateY" 
		"Sid_RigRN.placeHolderList[335]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateX" 
		"Sid_RigRN.placeHolderList[336]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateY" 
		"Sid_RigRN.placeHolderList[337]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.translateZ" 
		"Sid_RigRN.placeHolderList[338]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.visibility" 
		"Sid_RigRN.placeHolderList[339]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleX" 
		"Sid_RigRN.placeHolderList[340]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleY" 
		"Sid_RigRN.placeHolderList[341]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:IKOffsetLeg_L|Sid_Rig:IKExtraLeg_L|Sid_Rig:IKLeg_L|Sid_Rig:IKLegFootRockInnerPivot_L|Sid_Rig:IKLegFootRockOuterPivot_L|Sid_Rig:RollOffsetHeel_L|Sid_Rig:RollExtraHeel_L|Sid_Rig:RollHeel_L|Sid_Rig:RollOffsetToesEnd_L|Sid_Rig:RollExtraToesEnd_L|Sid_Rig:RollToesEnd_L|Sid_Rig:RollOffsetToes_L|Sid_Rig:RollExtraToes_L|Sid_Rig:RollToes_L.scaleZ" 
		"Sid_RigRN.placeHolderList[342]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateX" 
		"Sid_RigRN.placeHolderList[343]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateY" 
		"Sid_RigRN.placeHolderList[344]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.translateZ" 
		"Sid_RigRN.placeHolderList[345]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.follow" 
		"Sid_RigRN.placeHolderList[346]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:IKSystem|Sid_Rig:IKHandle|Sid_Rig:PoleOffsetLeg_L|Sid_Rig:PoleExtraLeg_L|Sid_Rig:PoleLeg_L.lock" 
		"Sid_RigRN.placeHolderList[347]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.FKIKBlend" 
		"Sid_RigRN.placeHolderList[348]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.IKVis" 
		"Sid_RigRN.placeHolderList[349]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_R|Sid_Rig:FKIKLeg_R.FKVis" 
		"Sid_RigRN.placeHolderList[350]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.FKIKBlend" 
		"Sid_RigRN.placeHolderList[351]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.IKVis" 
		"Sid_RigRN.placeHolderList[352]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_R|Sid_Rig:FKIKArm_R.FKVis" 
		"Sid_RigRN.placeHolderList[353]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.FKIKBlend" 
		"Sid_RigRN.placeHolderList[354]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.IKVis" 
		"Sid_RigRN.placeHolderList[355]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintSpine_M|Sid_Rig:FKIKSpine_M.FKVis" 
		"Sid_RigRN.placeHolderList[356]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.FKIKBlend" 
		"Sid_RigRN.placeHolderList[357]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.IKVis" 
		"Sid_RigRN.placeHolderList[358]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintLeg_L|Sid_Rig:FKIKLeg_L.FKVis" 
		"Sid_RigRN.placeHolderList[359]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.FKIKBlend" 
		"Sid_RigRN.placeHolderList[360]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.IKVis" 
		"Sid_RigRN.placeHolderList[361]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:FKIKSystem|Sid_Rig:FKIKParentConstraintArm_L|Sid_Rig:FKIKArm_L.FKVis" 
		"Sid_RigRN.placeHolderList[362]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateX" 
		"Sid_RigRN.placeHolderList[363]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateY" 
		"Sid_RigRN.placeHolderList[364]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.rotateZ" 
		"Sid_RigRN.placeHolderList[365]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.legLock" 
		"Sid_RigRN.placeHolderList[366]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.CenterBtwFeet" 
		"Sid_RigRN.placeHolderList[367]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateY" 
		"Sid_RigRN.placeHolderList[368]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateX" 
		"Sid_RigRN.placeHolderList[369]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:RootSystem|Sid_Rig:RootCenterBtwLegsBlended_M|Sid_Rig:RootOffsetX_M|Sid_Rig:RootExtraX_M|Sid_Rig:RootX_M.translateZ" 
		"Sid_RigRN.placeHolderList[370]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.indexCurl" 
		"Sid_RigRN.placeHolderList[371]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.middleCurl" 
		"Sid_RigRN.placeHolderList[372]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.pinkyCurl" 
		"Sid_RigRN.placeHolderList[373]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.thumbCurl" 
		"Sid_RigRN.placeHolderList[374]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_R.spread" 
		"Sid_RigRN.placeHolderList[375]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.indexCurl" 
		"Sid_RigRN.placeHolderList[376]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.middleCurl" 
		"Sid_RigRN.placeHolderList[377]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.pinkyCurl" 
		"Sid_RigRN.placeHolderList[378]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.thumbCurl" 
		"Sid_RigRN.placeHolderList[379]" ""
		5 4 "Sid_RigRN" "|Sid_Rig:Main|Sid_Rig:MotionSystem|Sid_Rig:DrivingSystem|Sid_Rig:Fingers_L.spread" 
		"Sid_RigRN.placeHolderList[380]" "";
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
createNode pairBlend -n "pairBlend1";
	rename -uid "BA9F3A53-4E8A-BB37-2146-648956F0AE88";
createNode animCurveTL -n "pairBlend1_inTranslateX1";
	rename -uid "AFA7E108-4443-0FA6-4158-9B9C74EC1A62";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -0.29949619419577639;
createNode animCurveTL -n "pairBlend1_inTranslateY1";
	rename -uid "240966C4-4888-D91D-4429-27BFC759EBFB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -10.213448418066555;
createNode animCurveTL -n "pairBlend1_inTranslateZ1";
	rename -uid "BE6B1900-4A9B-7224-C5BE-918AFB991CED";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -8.2264265010456583e-05;
createNode animCurveTL -n "Main_translateX";
	rename -uid "74B44D7D-427C-010F-0882-7EBFEB2EE294";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Main_translateY";
	rename -uid "22374E57-4B88-0C40-6EA3-1494025D17D1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Main_translateZ";
	rename -uid "988360BA-40F7-71AF-65C0-D794065F08E4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "FKSpine1_M_translateX";
	rename -uid "B05FC009-4BFD-251C-7AE5-EAAB83DF0730";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  1 0 11 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKSpine1_M_translateY";
	rename -uid "DD9E9C45-4895-7AE6-B09C-BD8080ECF330";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  1 0 11 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKSpine1_M_translateZ";
	rename -uid "F4FD3B02-4E38-13CB-F13C-05946C8E4E25";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  1 0 11 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKChest_M_translateX";
	rename -uid "DE429199-437B-6699-333B-719276EF28A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  2 0 12 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKChest_M_translateY";
	rename -uid "34A67A86-49DC-4993-E43D-85BAAA9ED9CF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  2 0 12 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKChest_M_translateZ";
	rename -uid "1D21A31F-4D14-CEB6-6574-78AD98588395";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  2 0 12 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKRoot_M_translateX";
	rename -uid "4AB4EC60-4160-DA8A-71E5-92A48397830C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKRoot_M_translateY";
	rename -uid "3EC3F6DC-4607-2E13-9F68-669AA9E71314";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKRoot_M_translateZ";
	rename -uid "94BFD9E2-4A48-D742-23CE-729343C05D3A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTL -n "FKHead_M_translateX";
	rename -uid "9111E61C-4632-319E-351F-8C910B1A973D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "FKHead_M_translateY";
	rename -uid "437A384A-40D5-C95B-D30B-4A98E6C81196";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "FKHead_M_translateZ";
	rename -uid "2E8F54A1-4C05-29C6-9146-BBA1D7792DF2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Bigote01_Ctrl_translateX";
	rename -uid "3C8845C9-4B24-85A1-A1B6-E6B866FF40B3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Bigote01_Ctrl_translateY";
	rename -uid "1EDBB142-4110-1A58-69B7-A79AF852852B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Bigote01_Ctrl_translateZ";
	rename -uid "B88109A1-4C65-FBA6-8D95-979DEC2E8FFB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Bigote02_Ctrl_translateX";
	rename -uid "C7A38295-4A6C-AD20-6782-F6A75C8E5265";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Bigote02_Ctrl_translateY";
	rename -uid "61F025E3-4F75-5FAE-873B-68AB1A9E27CD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Bigote02_Ctrl_translateZ";
	rename -uid "03E84C14-45CF-7581-FD20-8CB452997382";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Gorro_Ctrl_translateX";
	rename -uid "4C5F3536-4DDD-A65F-C1F3-AE8A631406EF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Gorro_Ctrl_translateY";
	rename -uid "4E44AE74-42DE-9DD8-2A38-61B871DAD9DC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "Gorro_Ctrl_translateZ";
	rename -uid "5F7A3FC2-4B27-D88C-949A-67A5B1F7FD0F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "IKLeg_L_translateX";
	rename -uid "83710170-4E3E-CAA3-607C-E28FD20DD50D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -1.6405599818412155;
createNode animCurveTL -n "IKLeg_L_translateY";
	rename -uid "1648D20E-4B4A-5B6C-DAC9-2DABF3AE3C1C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -0.064837783875117516;
createNode animCurveTL -n "IKLeg_L_translateZ";
	rename -uid "27166D66-4095-6A17-53B3-6D979492F931";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -3.5996495958424868;
createNode animCurveTL -n "RollHeel_L_translateX";
	rename -uid "B0812A6B-48E2-6446-3713-53B1C8A5AE72";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollHeel_L_translateY";
	rename -uid "B1BC6FE4-4AC3-5BEF-87B6-E69261876326";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollHeel_L_translateZ";
	rename -uid "9A171D7E-49AA-55BE-A94E-5EB9F5BF9B70";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToesEnd_L_translateX";
	rename -uid "DEAF5651-4CFE-3009-BD5E-AB8D5D8CC517";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToesEnd_L_translateY";
	rename -uid "B68F16BA-42D2-8FEB-E713-E98C7BC65BBE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToesEnd_L_translateZ";
	rename -uid "25AEF654-484B-FC70-5F76-6B931F197CCE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToes_L_translateX";
	rename -uid "1821A307-4D8E-D8A6-4E67-70AE8EDEAE71";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToes_L_translateY";
	rename -uid "17AA3B3B-4B0B-3322-3C73-61891BA811D4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToes_L_translateZ";
	rename -uid "1EAB0D5F-46E0-C6E5-6733-4A8D01902EDA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "IKLeg_R_translateX";
	rename -uid "D1B4E9C5-4A96-CED8-7F14-D2AFEA71F2E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "IKLeg_R_translateY";
	rename -uid "0327D6A6-4EB9-58D6-8E27-E4906CFEFB18";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "IKLeg_R_translateZ";
	rename -uid "664F3C67-4CD2-CC85-B5A5-91A7750EC551";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 4.1566612516171624;
createNode animCurveTL -n "RollHeel_R_translateX";
	rename -uid "1D801991-4E48-E891-2372-8797B66DFAE1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollHeel_R_translateY";
	rename -uid "6C70C847-489E-7BF1-0FC6-5FA399D7BBF6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollHeel_R_translateZ";
	rename -uid "15FCF61F-488D-B2DE-78F1-2FBEA98FC17C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToesEnd_R_translateX";
	rename -uid "75D8EC1E-4B5A-392E-0B9C-D9B0E9F7EA2B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToesEnd_R_translateY";
	rename -uid "35E629FC-4BB2-A408-6FCD-EAAF47D0F889";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToesEnd_R_translateZ";
	rename -uid "24C70C26-4E20-06BD-3B8D-06A38D6363FE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToes_R_translateX";
	rename -uid "348D28A1-43CA-1133-FE0A-6F964AE153E1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToes_R_translateY";
	rename -uid "DDD7E99C-422D-4965-3769-2EBF01DBAA2E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "RollToes_R_translateZ";
	rename -uid "3BF26791-4797-5A23-1604-B9A2E1424A4D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTL -n "PoleLeg_L_translateX";
	rename -uid "A7CD44B4-46E4-2890-449F-D3A050F6169A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 12.392818293028794;
createNode animCurveTL -n "PoleLeg_L_translateY";
	rename -uid "D8B34FA6-401C-981B-99E4-0A851FA7BDC3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 11.510433716634697;
createNode animCurveTL -n "PoleLeg_L_translateZ";
	rename -uid "BFCAF55B-4C82-81EA-1D45-E1AE19B5551F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -17.037701136300019;
createNode animCurveTL -n "PoleLeg_R_translateX";
	rename -uid "FEF763C7-4D45-4A2A-CD0A-DBAB9B349520";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -8.0108575741155601;
createNode animCurveTL -n "PoleLeg_R_translateY";
	rename -uid "079515DC-4A63-37FC-8396-68A80417CBB4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -0.63693181605165305;
createNode animCurveTL -n "PoleLeg_R_translateZ";
	rename -uid "C6D32D10-4F46-DB77-74DB-BE9A55604B5D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0.51625670924820699;
createNode animCurveTL -n "RootX_M_translateX";
	rename -uid "51F82A3D-4138-7E37-48DC-D3BD75CA9E5F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -0.29968661048557621;
createNode animCurveTL -n "RootX_M_translateY";
	rename -uid "36963912-49CA-4A40-8E48-4895A407D5B2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -10.213497917248466;
createNode animCurveTL -n "RootX_M_translateZ";
	rename -uid "9CF69463-4D02-36FD-37B1-CAB923F86C0D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKIKLeg_L_FKIKBlend";
	rename -uid "B3BDED3E-4E44-2789-2B2E-A59896E44F8B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 10;
createNode animCurveTU -n "FKIKLeg_L_FKVis";
	rename -uid "8294E586-4D17-0B03-5992-27B4AD39F41E";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTU -n "FKIKLeg_L_IKVis";
	rename -uid "208F7FE1-40E3-A517-661F-528D301CE46B";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "FKWrist_L_rotateX";
	rename -uid "C210DE80-47F7-3B50-5A81-53840790613F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKWrist_L_rotateY";
	rename -uid "34A9F1EC-4820-D750-5602-E6B8703D226F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKWrist_L_rotateZ";
	rename -uid "6B90D370-41AA-A66B-38D5-EF8A4C6D6E86";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateX";
	rename -uid "A39129B7-4294-FAFF-9D0F-B0B20BAAF424";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateY";
	rename -uid "785F247C-40E8-A86F-6840-80A76317CB60";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger2_L_rotateZ";
	rename -uid "9758A5AD-4B51-CAB1-B77D-FFB12837988A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Bigote01_Ctrl_visibility";
	rename -uid "AEDFD335-45E0-357B-A782-698C0E8A9909";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "Bigote01_Ctrl_rotateX";
	rename -uid "4F55FDD5-4D69-8DD6-EA27-9A8CCE5F55B4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Bigote01_Ctrl_rotateY";
	rename -uid "71F9D0D5-4A00-EC0B-DA9B-22AB5F8202C9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Bigote01_Ctrl_rotateZ";
	rename -uid "AE4F99FB-469B-1CDE-F2C4-C4A2FE875015";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Bigote01_Ctrl_scaleX";
	rename -uid "0B88F12E-4094-5DD4-8CF9-10B6530A8681";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "Bigote01_Ctrl_scaleY";
	rename -uid "ADC94F5B-4480-42D6-6612-1690F3D19A82";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "Bigote01_Ctrl_scaleZ";
	rename -uid "FFBAA4DD-4CE6-9B2D-2EB2-E0AEF8A989F9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToes_R_visibility";
	rename -uid "4E257961-40DF-16BE-AFD7-D7AB35D30972";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "RollToes_R_rotateX";
	rename -uid "731C5BCC-43B7-2949-F4F2-C4984E33670A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToes_R_rotateY";
	rename -uid "E6A4D337-40BC-1785-F90C-CFA2A7C16BD6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToes_R_rotateZ";
	rename -uid "80025FED-4BD4-E8BE-DE2A-BA83D3603E16";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollToes_R_scaleX";
	rename -uid "32F9FBDD-4DAF-9383-856F-559EC83D657E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToes_R_scaleY";
	rename -uid "B91B63FC-4974-1734-5DFA-7483C57BEC23";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToes_R_scaleZ";
	rename -uid "CCFECEEC-4263-50E6-0DAE-D2965BAFE09D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTA -n "FKShoulder1_R_rotateX";
	rename -uid "03095FAE-4221-DAB5-3CB7-5FA5A3257159";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -0.81879208786175994;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_R_rotateY";
	rename -uid "D8C214FB-4E7B-AF76-0947-DA8B357C4346";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 22.775669012268715;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_R_rotateZ";
	rename -uid "C9CF4755-41B7-2220-6836-AA89E2F5BE4A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -0.16491849573927111;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKIndexFinger2_L_rotateX";
	rename -uid "DF569529-4712-ED77-BDCC-22B09AC4B0FD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger2_L_rotateY";
	rename -uid "F43E3ECB-4045-5C7B-A0D3-26AA2C8DC7EB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger2_L_rotateZ";
	rename -uid "5319BC59-46BD-CA2F-5151-C4A6D6289D5D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger1_L_rotateX";
	rename -uid "0718194E-4062-9987-D3B9-D09A2A668BB5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger1_L_rotateY";
	rename -uid "767D25D5-46E7-4C9F-5487-DAB4C1574043";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger1_L_rotateZ";
	rename -uid "84DB5A28-433F-D9DD-3C92-6A86983903B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger1_R_rotateX";
	rename -uid "BDF36052-499C-6C4C-D9C2-B7A4B8EA26E3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger1_R_rotateY";
	rename -uid "09B61F12-47E2-BF1F-F56A-D9BFBC98E588";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger1_R_rotateZ";
	rename -uid "E40E38E0-44BA-5469-BE54-6F9AE707DABB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Bigote02_Ctrl_visibility";
	rename -uid "79DE3ADA-470C-00E0-8B3C-09B965044CC4";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "Bigote02_Ctrl_rotateX";
	rename -uid "5F072978-478B-69BD-A6E7-CB8272DE5A08";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Bigote02_Ctrl_rotateY";
	rename -uid "8041185F-40A1-7D28-31FE-D19117F21DFE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Bigote02_Ctrl_rotateZ";
	rename -uid "30367BD8-480B-63AD-379A-F9B8A0238D46";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Bigote02_Ctrl_scaleX";
	rename -uid "6A075211-4454-CB8E-3904-509FB45A3E30";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "Bigote02_Ctrl_scaleY";
	rename -uid "26BEF452-45B7-F9AD-0EE9-4191483DF96E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "Bigote02_Ctrl_scaleZ";
	rename -uid "1980F364-4D52-0735-ACD8-A882155D35CC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateX";
	rename -uid "8F72CB24-4D71-59CD-56ED-A8BDACBE806D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateY";
	rename -uid "F6FAC054-436C-8BD3-F990-50AB466D7CD9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger3_R_rotateZ";
	rename -uid "DEE5BDD0-4612-D15C-83AD-99A5070CA06F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKSpine1_M_uiTreatment";
	rename -uid "A199B64E-4B51-A954-9AD3-60B5DC3850EE";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  1 0 11 0;
	setAttr -s 2 ".kot[0:1]"  5 5;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKSpine1_M_rotateX";
	rename -uid "68B0B1D8-44C5-2E78-150C-069403D99A8B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  1 0 11 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKSpine1_M_rotateY";
	rename -uid "D6F60CB5-4533-42EF-17BE-1B8699DE8F10";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  1 0 11 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKSpine1_M_rotateZ";
	rename -uid "9DAB3A51-4AEE-C14B-95F4-AA9C4CBEA328";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  1 1.1543649122602464 8 -0.41175156927454276
		 11 1.1543649122602464;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "Gorro_Ctrl_rotateX";
	rename -uid "9C34C732-476A-A4DA-2A51-91AC8D0E9A24";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Gorro_Ctrl_rotateY";
	rename -uid "51647956-4959-0730-F8C3-9BBCCD61E466";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Gorro_Ctrl_rotateZ";
	rename -uid "44D26BBF-40DE-7FFB-34B2-E3848332FDFA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "pairBlend1_inRotateX1";
	rename -uid "6C374EA2-43D6-0E20-8875-D49CBE4967C4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -3.1805546814639195e-15;
createNode animCurveTA -n "pairBlend1_inRotateY1";
	rename -uid "C7DEFD59-4D78-5B78-08BE-2B91922E705E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -2.7352770260586246e-13;
createNode animCurveTA -n "pairBlend1_inRotateZ1";
	rename -uid "EB768E2E-4E54-8668-BD42-F3A380B6FF29";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1.6856939811756638e-13;
createNode animCurveTU -n "Collar_Ctrl_Master_blendParent1";
	rename -uid "C59F580A-402C-72F2-5226-5087E3C63277";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "IKLeg_R_rotateX";
	rename -uid "03060AED-4474-196D-41C3-628C6814445A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -7.3224101209077093;
createNode animCurveTA -n "IKLeg_R_rotateY";
	rename -uid "7AE064C2-4B9C-C9FD-16E3-E989CBCB30E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 12.38091466521024;
createNode animCurveTA -n "IKLeg_R_rotateZ";
	rename -uid "ABA774E5-408D-A651-C144-FDBD620C6F5E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 35.830092648313666;
createNode animCurveTU -n "IKLeg_R_toe";
	rename -uid "27C3FE94-4CF9-CB9E-DA29-959FD0E6B9E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_R_roll";
	rename -uid "266FE926-42A8-CADC-54BD-31A7B5800830";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_R_rollAngle";
	rename -uid "DA914390-4EDD-CA54-D207-15841F346E88";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 25;
createNode animCurveTU -n "IKLeg_R_stretchy";
	rename -uid "3946E979-4611-2DB9-60DD-7CB4FD7E1CBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_R_antiPop";
	rename -uid "7E55623D-4019-37A6-93A2-048B27CACFEF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_R_Lenght1";
	rename -uid "52FD160F-497B-EA20-3334-10907D25AFE5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "IKLeg_R_Lenght2";
	rename -uid "FFB28791-4F66-6A51-23FE-D89386CF2565";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "IKLeg_R_volume";
	rename -uid "0C3C2F86-46C5-90FE-2BDF-8CBC0B89349B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 10;
createNode animCurveTU -n "FKIKSpine_M_FKIKBlend";
	rename -uid "5D5C6AD4-44C0-7250-1F6E-B2A7AEB36C95";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKIKSpine_M_FKVis";
	rename -uid "D25A316D-4B33-E620-C241-D38CDBA0380A";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTU -n "FKIKSpine_M_IKVis";
	rename -uid "52FBCAE5-490E-2720-9EAF-C5B7C0457D22";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "FKElbow1_R_rotateX";
	rename -uid "A7200194-4052-6960-648B-BFB49CA48EC4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotateY";
	rename -uid "A7B6CB45-480F-C798-8FC2-F99C5BCAF743";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotateZ";
	rename -uid "EF2A9001-4A25-BB8E-913E-72B994E1F85B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder_R_rotateX";
	rename -uid "0EB6F877-4809-61A0-6548-3C9F4E0DBE1E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKShoulder_R_rotateY";
	rename -uid "87BAA722-4544-B372-520D-9E8F563BC369";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -24.757869354708969;
createNode animCurveTA -n "FKShoulder_R_rotateZ";
	rename -uid "1B77DFD7-4470-0EB1-6BA4-D1919189E610";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "IKLeg_L_rotateX";
	rename -uid "9063B6B9-4394-5E51-F52B-0DBEE5E24B8D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -5.2885949324867054;
createNode animCurveTA -n "IKLeg_L_rotateY";
	rename -uid "8A96870B-405C-C945-5E4D-38A71D60D46A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -7.3486815339491853;
createNode animCurveTA -n "IKLeg_L_rotateZ";
	rename -uid "1DDCA5B7-45C0-C494-16CB-59962977B7D4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -45.869423301413185;
createNode animCurveTU -n "IKLeg_L_toe";
	rename -uid "D515B2E6-4DCC-6D74-F976-E188AD460D9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_L_roll";
	rename -uid "7A78A4EB-4088-B4CC-B355-46B14B36BEBC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_L_rollAngle";
	rename -uid "623BCDB7-4027-F6FF-5D7B-65A038EE3B82";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 25;
createNode animCurveTU -n "IKLeg_L_stretchy";
	rename -uid "16CB41BB-47FB-22FD-1838-40B6C244A301";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_L_antiPop";
	rename -uid "1D476744-4C19-6E53-53CF-26A03304D0D7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "IKLeg_L_Lenght1";
	rename -uid "2BC3D4B3-432A-2CE2-A357-3AA75DA074D3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "IKLeg_L_Lenght2";
	rename -uid "65660A88-438F-840A-ED8A-9985A0D546A4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "IKLeg_L_volume";
	rename -uid "A5B9DF2D-4718-969A-549B-5B9A8C7710CD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 10;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateX";
	rename -uid "83189849-4306-FF1E-EBA5-3F960B8CEDA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateY";
	rename -uid "39C1E2C1-4BD9-A88C-D3E0-4C9377649155";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger1_L_rotateZ";
	rename -uid "809F312C-4C48-BDAC-C417-1D9206064F7B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollToesEnd_L_visibility";
	rename -uid "250E1616-4FDC-AF3D-FB79-AA9A5829A6B8";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "RollToesEnd_L_rotateX";
	rename -uid "3E428B4F-44D4-A07B-2D56-8EA57034F555";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToesEnd_L_rotateY";
	rename -uid "DCE503AF-457A-BE74-4D0B-5596B313197A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToesEnd_L_rotateZ";
	rename -uid "FCA6C007-4495-D82B-63E6-2E8CAC8E22D7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollToesEnd_L_scaleX";
	rename -uid "6D223198-4601-47DD-D4A5-C1817340ADB3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToesEnd_L_scaleY";
	rename -uid "C2BBEB61-4766-AF57-4801-4C9222F6F87E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToesEnd_L_scaleZ";
	rename -uid "EEAF8B88-4C97-0315-00F1-B5991FD75C7B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTA -n "FKToes_R_rotateX";
	rename -uid "354760EE-4EE8-AFDD-A3EA-C6A645A7A83A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKToes_R_rotateY";
	rename -uid "BE6F106B-4AE3-FD86-80A6-7E900F873C86";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKToes_R_rotateZ";
	rename -uid "D256E147-4370-62DF-E0EE-41BCDFC22701";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateX";
	rename -uid "3C9E511A-4376-850E-C95B-3D81B546C558";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateY";
	rename -uid "7A4B0272-4CB3-F972-B296-038ADFE413A8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger3_R_rotateZ";
	rename -uid "D2E6EC6D-46A6-D255-DD62-C9B23649CE5C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKIKLeg_R_FKIKBlend";
	rename -uid "372BBA14-4C6B-CC3F-6CAA-C7B4F7972F07";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 10;
createNode animCurveTU -n "FKIKLeg_R_FKVis";
	rename -uid "FFD83DA5-4825-9D81-6D04-2B9516B1FDB7";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTU -n "FKIKLeg_R_IKVis";
	rename -uid "155394EE-4B28-774C-B42D-579E955A0BAD";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "FKIndexFinger2_R_rotateX";
	rename -uid "624504E3-4E30-0E80-7FC8-0CBA2A8CD545";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger2_R_rotateY";
	rename -uid "81C836B8-44BE-ED2E-80D4-FCA9F9DA44A7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger2_R_rotateZ";
	rename -uid "F0E75BD1-41F7-A53E-B268-1FB6D8882E36";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKElbow_L_rotateX";
	rename -uid "64B821E1-4249-515C-91E4-1AA95B979DCC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 0;
createNode animCurveTA -n "FKElbow_L_rotateY";
	rename -uid "05CB3F5E-4AAB-451E-2FE7-C48B63CBD3DA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 0;
createNode animCurveTA -n "FKElbow_L_rotateZ";
	rename -uid "5CD4EBDB-47E2-8E42-20D8-8395797C99F1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 45.05053103976055;
createNode animCurveTA -n "FKThumbFinger3_L_rotateX";
	rename -uid "7B7C7DC6-462E-5450-A164-D9A4996856DF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger3_L_rotateY";
	rename -uid "F43450D4-4C1C-76ED-FEC7-8BAF576F3B76";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger3_L_rotateZ";
	rename -uid "34C6650F-4D8F-16ED-16EA-71A7D9CAA46C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateX";
	rename -uid "6883F248-4390-08E6-2709-A6A82EDFA615";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateY";
	rename -uid "5E4EA3C4-4C0C-F110-E158-948422BF72AE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger2_R_rotateZ";
	rename -uid "3B59CBE4-4529-F188-F13E-8880ACD7A57A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateX";
	rename -uid "07E953E1-456C-4B8D-D12B-DB88AB16E0C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateY";
	rename -uid "E79BA0BF-48B6-2E58-482B-07BFACC70D8A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger3_L_rotateZ";
	rename -uid "EFAC65D0-4059-BE91-F0A2-A681F27C2402";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger2_L_rotateX";
	rename -uid "C5B594DC-49F4-83F2-ED12-EDA17A919055";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger2_L_rotateY";
	rename -uid "45E6ADA5-48FC-367A-6B6F-DF8D6C0874C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger2_L_rotateZ";
	rename -uid "AB4330B0-4FD7-2AF0-F568-0099251C4E99";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_L_indexCurl";
	rename -uid "C546F346-4224-C913-73E1-8381CBB4481E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_L_middleCurl";
	rename -uid "454160B9-476F-3AA1-9EC3-99A70BBFDA15";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_L_pinkyCurl";
	rename -uid "6FA23FE6-447A-B3A5-96E6-03B0DDC153E3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_L_thumbCurl";
	rename -uid "8EF54A98-4DAE-1E9E-F7E7-47BC4BCBCA33";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_L_spread";
	rename -uid "FEFB3EC0-4B51-2712-50A4-1C91F4ECC2D1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollToesEnd_R_visibility";
	rename -uid "AA0D8361-4C0E-BAB1-F131-A19000BD43BC";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "RollToesEnd_R_rotateX";
	rename -uid "60EB9F6D-45D4-344F-BE5F-199B7665CCC1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToesEnd_R_rotateY";
	rename -uid "7D8757C9-4D0C-F3E9-4E0A-3B87C1E684F3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToesEnd_R_rotateZ";
	rename -uid "4EA195B6-4775-82A7-51DA-6493EC1A4DA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollToesEnd_R_scaleX";
	rename -uid "6CD7F1FE-45C8-6E89-36FC-9E859DBD5F92";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToesEnd_R_scaleY";
	rename -uid "DEEBEDA1-4356-0544-9F67-9CA01CA397A1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToesEnd_R_scaleZ";
	rename -uid "F6249012-4C82-D21B-03BD-3CA762B4E916";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTA -n "FKWrist_R_rotateX";
	rename -uid "84CF88BC-4F7A-761C-4A55-1784F40698B1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotateY";
	rename -uid "258FB152-445F-5E1E-AF93-9E971900E399";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotateZ";
	rename -uid "FEDA6790-4F5D-4BE7-F8AF-E5BC52014A41";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKToes_L_rotateX";
	rename -uid "D382F731-4E58-B878-AEC0-99ACD4303EC3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKToes_L_rotateY";
	rename -uid "33155F05-4B51-4F3A-579D-D2A0A812A402";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKToes_L_rotateZ";
	rename -uid "375D3259-447D-DC40-6DF3-4981762504C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "PoleLeg_R_follow";
	rename -uid "44C98C60-4B3B-4FA5-CA70-02A3C716C08B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 10;
createNode animCurveTU -n "PoleLeg_R_lock";
	rename -uid "74891537-4167-E0D7-5068-4CB2E3B5BB30";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger3_R_rotateX";
	rename -uid "677FCE5C-4F68-F148-1287-BFAE5E0AF120";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger3_R_rotateY";
	rename -uid "DC0FE8BE-4F48-1390-6964-EBA6D2AF8F4D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger3_R_rotateZ";
	rename -uid "501D076C-4C8B-4992-43EF-8786C1E26C08";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateX";
	rename -uid "39BC9CFB-48FA-0FDD-8B91-2FBDF6FD8F3C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateY";
	rename -uid "17AF834C-4811-A84C-82B0-61AD56103675";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger1_L_rotateZ";
	rename -uid "5637C309-4380-8022-57D0-BF8D2F1033AC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKIKArm_L_FKIKBlend";
	rename -uid "F47C6363-4F46-AEA2-BAAB-FFB13B0EAEFC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKIKArm_L_FKVis";
	rename -uid "B2A8D2E6-4E15-78F8-298D-9D84842BA2C9";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTU -n "FKIKArm_L_IKVis";
	rename -uid "84111913-4689-0753-1E9B-49A68227D5BD";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateX";
	rename -uid "EF41A7AD-41DD-2915-190B-1D8F3CFF1EA0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateY";
	rename -uid "97B10492-411C-3A08-9CA4-15A93BE3C45C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger3_L_rotateZ";
	rename -uid "C89EBF5B-4239-0CFD-021F-A4A62183CA36";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKElbow_R_rotateX";
	rename -uid "3775208B-471A-A72A-9C82-18842C1661C8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotateY";
	rename -uid "5BFE39B8-4465-728A-7ACE-799164536697";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotateZ";
	rename -uid "F3C3EFC0-4A51-D8F0-F555-F18D0FE4C95C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 50.090590022106532;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "RootX_M_rotateX";
	rename -uid "7AA92CBA-4B72-53CC-25E1-988071524AD1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RootX_M_rotateY";
	rename -uid "5DC9C89D-4BB4-CF6C-F3C1-8C8DF4F45FA3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RootX_M_rotateZ";
	rename -uid "B8B9793E-4A76-9DD9-6FEE-A99256DE0698";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RootX_M_legLock";
	rename -uid "BC2775C6-4234-2EA7-B393-E18AE336EA18";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RootX_M_CenterBtwFeet";
	rename -uid "E02547F9-4694-951F-B0F7-E09A5EBA73C4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollHeel_R_visibility";
	rename -uid "9027328A-492E-3395-192A-6E86078BD5AD";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "RollHeel_R_rotateX";
	rename -uid "36DDFB76-4B4F-6FA9-5802-3BA5B56C566C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollHeel_R_rotateY";
	rename -uid "7E9ED661-41C2-7FB8-EBD9-5F9A6AEB12F7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollHeel_R_rotateZ";
	rename -uid "F134D63C-425F-6079-FB2B-38A59C5E1C57";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollHeel_R_scaleX";
	rename -uid "E13AC2E9-4502-2E73-21C6-C3A169C447BE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollHeel_R_scaleY";
	rename -uid "491EF999-4764-37E9-4EFD-54A3435710FC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollHeel_R_scaleZ";
	rename -uid "28964DBE-43E3-4794-5F7A-93AA27BF29A2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTA -n "FKThumbFinger3_R_rotateX";
	rename -uid "4982DCE7-4AD8-DA7C-778D-E6BD6CF0EEB3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger3_R_rotateY";
	rename -uid "5513CADA-408C-6170-A6BF-6A8C22E02BD2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger3_R_rotateZ";
	rename -uid "37BC4D9D-417A-CA19-55AD-F38BABDF1736";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKIKArm_R_FKIKBlend";
	rename -uid "239C129B-45B4-A2BF-CE42-249510AB5DE3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "FKIKArm_R_FKVis";
	rename -uid "A1B9D435-4633-503E-D8B6-829EC67AC097";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTU -n "FKIKArm_R_IKVis";
	rename -uid "314CD6CA-4441-1FBF-DE0F-6B88A9958F38";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateX";
	rename -uid "904451BC-4DF4-E191-587D-369832B27128";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateY";
	rename -uid "B7AA9332-45B8-AEE4-BC1C-65AE5D52DBEF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger2_L_rotateZ";
	rename -uid "A7ECD5D6-45FD-7103-DF4A-F08FC47FAE88";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKShoulder_L_rotateX";
	rename -uid "3C03F0E0-4F90-865A-D07F-9499877207EE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKShoulder_L_rotateY";
	rename -uid "D6E23108-48E3-A51E-A816-7899543E8BE0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 -24.610912320241468;
createNode animCurveTA -n "FKShoulder_L_rotateZ";
	rename -uid "55487353-4F8B-D051-0FB8-9182F9800808";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger2_R_rotateX";
	rename -uid "F2A2ECAF-4FA8-FD0C-0A99-41B4D75F5914";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger2_R_rotateY";
	rename -uid "E7C73FD1-4C9E-F6D8-E4E9-5183DFE5C232";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger2_R_rotateZ";
	rename -uid "11819E98-43AE-C2E3-8423-298553AA4CC1";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKRoot_M_rotateX";
	rename -uid "A0ED576D-4590-0B79-4018-03B7E78D364A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKRoot_M_rotateY";
	rename -uid "44001EF1-4079-38D4-F3FD-5DB3D2C2728A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKRoot_M_rotateZ";
	rename -uid "7EA60500-4D65-BA0F-5972-5CAF66D4F152";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 1.1543649122602464 7 -0.41175156927454276
		 10 1.1543649122602464;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "RollHeel_L_visibility";
	rename -uid "9EB9E70A-4FD5-8DE1-5236-CAB12FDEF189";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "RollHeel_L_rotateX";
	rename -uid "04114C50-41B4-CF51-F4A1-9C973AF8E92D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollHeel_L_rotateY";
	rename -uid "AEBFD233-4F6B-D6CE-5CE1-0181ECB04DFC";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollHeel_L_rotateZ";
	rename -uid "88D4020C-4EA5-5EB0-B858-E988E4E553FF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollHeel_L_scaleX";
	rename -uid "B12C9645-4CF9-403C-A2A8-E88B82754626";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollHeel_L_scaleY";
	rename -uid "9857A7D1-4794-1AFA-D155-6CBDDC54AB69";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollHeel_L_scaleZ";
	rename -uid "D6E49EF3-4E41-20F1-BC60-059D4B566209";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "Fingers_R_indexCurl";
	rename -uid "B840517A-490F-2640-CFF8-4FBCCA526FE8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_R_middleCurl";
	rename -uid "C0DE5C8E-4CFC-100C-4E1E-F989B28FEA2D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_R_pinkyCurl";
	rename -uid "7712B62B-4E85-5363-EADA-2E84BB6203C3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_R_thumbCurl";
	rename -uid "830B00AC-4798-BA56-91E6-EBBE1587062C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Fingers_R_spread";
	rename -uid "B8AAD17D-4720-C944-0726-6799FEA6EE67";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKElbow1_L_rotateX";
	rename -uid "A59C3C19-4FA0-5558-D6CD-7DB73494CC13";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 0;
createNode animCurveTA -n "FKElbow1_L_rotateY";
	rename -uid "03AAFDF5-46BB-FA97-7EBB-A5B3BF611B59";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 0;
createNode animCurveTA -n "FKElbow1_L_rotateZ";
	rename -uid "5EC8FB12-4C46-C56F-CE86-24B5AF13D8F4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 0;
createNode animCurveTU -n "RollToes_L_visibility";
	rename -uid "23666FC1-4739-4481-F79C-AFB8D757D825";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "RollToes_L_rotateX";
	rename -uid "2933A661-42CC-C9FA-0C9A-2DAD565EB114";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToes_L_rotateY";
	rename -uid "A76C09F0-4B59-3395-390B-5988E2CE94D0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "RollToes_L_rotateZ";
	rename -uid "436068D1-464E-5584-EBB7-A6B4420B6C5E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "RollToes_L_scaleX";
	rename -uid "BBF51867-4002-15AE-60E6-BF8F4642B594";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToes_L_scaleY";
	rename -uid "E9F618D0-40BE-B832-F831-D0AD2ED816B4";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "RollToes_L_scaleZ";
	rename -uid "F81AE3D7-4C1E-9681-9E8D-D7A322C15646";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTA -n "FKChest_M_rotateX";
	rename -uid "6F327D25-44A6-0BD1-2CE4-67A2F190C3AD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  2 0 12 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKChest_M_rotateY";
	rename -uid "FADBF6E2-4EE7-D93A-FA84-2185AE7D1BF8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  2 0 12 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKChest_M_rotateZ";
	rename -uid "C7652997-4EE5-6298-6ADC-A58E9DEF07E0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  2 1.1543649122602464 9 -0.41175156927454276
		 12 1.1543649122602464;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_L_rotateX";
	rename -uid "F9422A19-41A6-0235-E085-53A1489C28D3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 -0.80773869967510636;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_L_rotateY";
	rename -uid "CAAF66C8-4E75-56FD-6A5D-A0B1E445A45F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 22.499045270481684;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_L_rotateZ";
	rename -uid "09878C23-4B8E-5D9A-7920-D59A88929372";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 -0.16066477663967832;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateX";
	rename -uid "E3A05ECA-4756-C0AA-D049-83AEEE88AA76";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateY";
	rename -uid "AB975222-42FD-3F50-F75C-8CB94D993C44";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKMiddleFinger1_R_rotateZ";
	rename -uid "3491E7BC-40CD-7C05-52BC-D4B8A628313D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "HipSwinger_M_rotateX";
	rename -uid "865F9B40-4FD1-5CEC-44E3-5C862033E7F5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 10.333828 2 8.990724 4 -9.0005384999999993
		 6 -16.178949500000002 8 -17.811422 10 10.333828;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "HipSwinger_M_rotateY";
	rename -uid "B34BCC3C-465B-AECF-0E97-2D89722897A5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 1.1896015 2 15.941603 4 17.0594155 6 1.7315484999999999
		 8 -20.597573 10 1.1896015;
	setAttr -s 6 ".kit[0:5]"  1 18 18 18 18 1;
	setAttr -s 6 ".kot[0:5]"  1 18 18 18 18 1;
	setAttr -s 6 ".kix[0:5]"  0.1188100861154008 0.81833040908479104 
		1 0.24580603314314617 1 0.11971756148072617;
	setAttr -s 6 ".kiy[0:5]"  0.99291699725468041 0.57474806791073119 
		0 -0.96931903626743576 0 0.99280799023431954;
	setAttr -s 6 ".kox[0:5]"  0.11881003564654852 0.81833040908479104 
		1 0.24580603314314617 1 0.11971755372071513;
	setAttr -s 6 ".koy[0:5]"  0.99291700329366206 0.57474806791073119 
		0 -0.96931903626743576 0 0.9928079911700588;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "HipSwinger_M_rotateZ";
	rename -uid "B975BD8F-49F9-7A11-66D5-ACB992EF2B64";
	setAttr ".tan" 1;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 -13.979505 2 -19.074643500000004 4 -14.924897499999998
		 6 17.0540065 8 17.934836499999999 10 -13.979505;
	setAttr -s 6 ".kit[1:5]"  18 18 1 1 1;
	setAttr -s 6 ".kot[1:5]"  18 18 1 1 1;
	setAttr -s 6 ".kix[0:5]"  0.33543217685059051 1 0.35809558510628914 
		0.34366361582303062 0.69111895269398427 0.33591820650214965;
	setAttr -s 6 ".kiy[0:5]"  -0.94206435806333011 0 0.93368493183053158 
		0.93909281711630632 -0.7227410277735522 -0.94189116066580603;
	setAttr -s 6 ".kox[0:5]"  0.3354321539665453 1 0.35809558510628919 
		0.34366356404618148 0.69111892384893958 0.33591804314974177;
	setAttr -s 6 ".koy[0:5]"  -0.94206436621144085 0 0.93368493183053158 
		0.93909283606418603 -0.72274105535653899 -0.9418912189241645;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTU -n "HipSwinger_M_stabilize";
	rename -uid "8C20521B-445B-3FDF-40C7-73A9F86D1194";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 10 10 10;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKHead_M_rotateX";
	rename -uid "A2EBA666-4486-1A22-7523-C6A59586F8C7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKHead_M_rotateY";
	rename -uid "43B32E4A-4283-08F1-C195-478C672695E5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKHead_M_rotateZ";
	rename -uid "0F3C6EFA-4196-CA87-709B-4EA7A8159003";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateX";
	rename -uid "E0065C76-4AFA-09EF-3BCF-F0BDA4AB5782";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateY";
	rename -uid "27F7F03E-4D0D-9EA0-0BF3-0C8412F74507";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger2_R_rotateZ";
	rename -uid "79B1D274-4D6B-93ED-F267-E395B597E257";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateX";
	rename -uid "9104DAC2-471C-EB0F-1884-D7A84B938B9F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateY";
	rename -uid "95BB47B6-4CAC-9000-F4E2-D08D5CA4856F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKPinkyFinger1_R_rotateZ";
	rename -uid "A02E820C-404B-BEE9-E6F8-FB91CF70441B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger3_L_rotateX";
	rename -uid "38B1DC7A-4DBF-90E8-0776-4AA7AD50845F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger3_L_rotateY";
	rename -uid "6116ABA1-4532-FAB1-3F66-3994C9AAA821";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger3_L_rotateZ";
	rename -uid "9B4E431F-4A58-0AF0-503E-D490B4B51266";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "PoleLeg_L_follow";
	rename -uid "005F7A7E-4B8F-DE36-7D7D-B98318ABBC43";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 10;
createNode animCurveTU -n "PoleLeg_L_lock";
	rename -uid "A6096F89-40A1-F767-ED8B-4D8D1D8248B0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Main_visibility";
	rename -uid "E16CD8AA-49C5-E067-B823-439C043CF059";
	setAttr ".tan" 9;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
	setAttr ".kot[0]"  5;
createNode animCurveTA -n "Main_rotateX";
	rename -uid "B17C4F86-498D-B2CB-074B-D2AC99FD0093";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Main_rotateY";
	rename -uid "B089D314-46CA-5EBE-D43D-3EBB7C4BC4F2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "Main_rotateZ";
	rename -uid "D35BA6DD-40DE-77F8-C5AC-908D070292A3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTU -n "Main_scaleX";
	rename -uid "3A0A29E3-47EE-3F72-0E76-629D8C236556";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "Main_scaleY";
	rename -uid "C8DD4918-44F1-A6E0-A10F-809E73B9A640";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTU -n "Main_scaleZ";
	rename -uid "244BCEA4-480E-E164-3B27-5FB86E412BD2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 1;
createNode animCurveTA -n "FKIndexFinger1_L_rotateX";
	rename -uid "AC322509-4982-6580-0EA5-A9A1AEFA7126";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger1_L_rotateY";
	rename -uid "3203E1EE-4E5A-1FF2-8F4A-D0814941AB4E";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKIndexFinger1_L_rotateZ";
	rename -uid "84DD0220-4835-3506-C502-AC80A3725936";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger1_R_rotateX";
	rename -uid "4DC84C93-4CB8-0C9B-4A2F-7697DCBF85F5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger1_R_rotateY";
	rename -uid "0777CDC8-401B-16EE-120D-39A2EDD1F0B6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode animCurveTA -n "FKThumbFinger1_R_rotateZ";
	rename -uid "7AC4C05A-48AA-5F69-1884-69B6DFB87E47";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
createNode script -n "uiConfigurationScriptNode";
	rename -uid "477E4B29-405C-2CE9-D0D2-0091972A2B19";
	setAttr ".b" -type "string" (
		"// Maya Mel UI Configuration File.\n//\n//  This script is machine generated.  Edit at your own risk.\n//\n//\n\nglobal string $gMainPane;\nif (`paneLayout -exists $gMainPane`) {\n\n\tglobal int $gUseScenePanelConfig;\n\tint    $useSceneConfig = $gUseScenePanelConfig;\n\tint    $nodeEditorPanelVisible = stringArrayContains(\"nodeEditorPanel1\", `getPanel -vis`);\n\tint    $nodeEditorWorkspaceControlOpen = (`workspaceControl -exists nodeEditorPanel1Window` && `workspaceControl -q -visible nodeEditorPanel1Window`);\n\tint    $menusOkayInPanels = `optionVar -q allowMenusInPanels`;\n\tint    $nVisPanes = `paneLayout -q -nvp $gMainPane`;\n\tint    $nPanes = 0;\n\tstring $editorName;\n\tstring $panelName;\n\tstring $itemFilterName;\n\tstring $panelConfig;\n\n\t//\n\t//  get current state of the UI\n\t//\n\tsceneUIReplacement -update $gMainPane;\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Top View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|top\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n"
		+ "            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -controllers 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n"
		+ "            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1\n            -height 1\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n"
		+ "\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Side View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|side\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n"
		+ "            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n"
		+ "            -sortTransparent 1\n            -controllers 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1\n            -height 1\n"
		+ "            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Front View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|front\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n"
		+ "            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n"
		+ "            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -controllers 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n"
		+ "            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1\n            -height 1\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Persp View\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"|persp\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n"
		+ "            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -holdOuts 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 1\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 32768\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -depthOfFieldPreview 1\n            -maxConstantTransparency 1\n            -rendererName \"vp2Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n"
		+ "            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -controllers 0\n            -nurbsCurves 0\n            -nurbsSurfaces 0\n            -polymeshes 1\n            -subdivSurfaces 0\n            -planes 0\n            -lights 0\n            -cameras 0\n            -controlVertices 0\n            -hulls 0\n            -grid 0\n            -imagePlane 0\n            -joints 0\n            -ikHandles 0\n            -deformers 0\n            -dynamics 0\n            -particleInstancers 0\n            -fluids 0\n            -hairSystems 0\n            -follicles 0\n"
		+ "            -nCloths 0\n            -nParticles 0\n            -nRigids 0\n            -dynamicConstraints 0\n            -locators 0\n            -manipulators 1\n            -pluginShapes 0\n            -dimensions 0\n            -handles 0\n            -pivots 0\n            -textures 0\n            -strokes 0\n            -motionTrails 0\n            -clipGhosts 0\n            -greasePencils 0\n            -shadows 0\n            -captureSequenceNumber -1\n            -width 1874\n            -height 1056\n            -sceneRenderFilter 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"ToggledOutliner\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"ToggledOutliner\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -docTag \"isolOutln_fromSeln\" \n            -showShapes 0\n            -showAssignedMaterials 0\n            -showTimeEditor 1\n            -showReferenceNodes 1\n            -showReferenceMembers 1\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -organizeByClip 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showParentContainers 0\n            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUpstreamCurves 1\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n"
		+ "            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n            -showSetMembers 1\n            -allowMultiSelection 1\n            -alwaysToggleSelect 0\n            -directSelect 0\n            -isSet 0\n            -isSetMember 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n            -niceNames 1\n            -showNamespace 1\n            -showPinIcons 0\n            -mapMotionTrails 0\n            -ignoreHiddenAttribute 0\n            -ignoreOutlinerColor 0\n            -renderFilterVisible 0\n            -renderFilterIndex 0\n            -selectionOrder \"chronological\" \n"
		+ "            -expandAttribute 0\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"Outliner\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -showShapes 0\n            -showAssignedMaterials 0\n            -showTimeEditor 1\n            -showReferenceNodes 0\n            -showReferenceMembers 0\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -organizeByClip 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showParentContainers 0\n"
		+ "            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUpstreamCurves 1\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n            -showSetMembers 1\n            -allowMultiSelection 1\n            -alwaysToggleSelect 0\n            -directSelect 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n"
		+ "            -niceNames 1\n            -showNamespace 1\n            -showPinIcons 0\n            -mapMotionTrails 0\n            -ignoreHiddenAttribute 0\n            -ignoreOutlinerColor 0\n            -renderFilterVisible 0\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"graphEditor\" (localizedPanelLabel(\"Graph Editor\")) `;\n\tif (\"\" != $panelName) {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showAssignedMaterials 0\n                -showTimeEditor 1\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -organizeByClip 1\n"
		+ "                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showParentContainers 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n"
		+ "                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                -ignoreOutlinerColor 0\n                -renderFilterVisible 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayValues 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showPlayRangeShades \"on\" \n                -lockPlayRangeShades \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1\n                -resultScreenSamples 0\n"
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
		+ "\t\t\t\t-userCreated false\n\t\t\t\t-defaultImage \"vacantCell.xP:/\"\n\t\t\t\t-image \"\"\n\t\t\t\t-sc false\n\t\t\t\t-configString \"global string $gMainPane; paneLayout -e -cn \\\"single\\\" -ps 1 100 100 $gMainPane;\"\n\t\t\t\t-removeAllPanels\n\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Persp View\")) \n\t\t\t\t\t\"modelPanel\"\n"
		+ "\t\t\t\t\t\"$panelName = `modelPanel -unParent -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 1\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -controllers 0\\n    -nurbsCurves 0\\n    -nurbsSurfaces 0\\n    -polymeshes 1\\n    -subdivSurfaces 0\\n    -planes 0\\n    -lights 0\\n    -cameras 0\\n    -controlVertices 0\\n    -hulls 0\\n    -grid 0\\n    -imagePlane 0\\n    -joints 0\\n    -ikHandles 0\\n    -deformers 0\\n    -dynamics 0\\n    -particleInstancers 0\\n    -fluids 0\\n    -hairSystems 0\\n    -follicles 0\\n    -nCloths 0\\n    -nParticles 0\\n    -nRigids 0\\n    -dynamicConstraints 0\\n    -locators 0\\n    -manipulators 1\\n    -pluginShapes 0\\n    -dimensions 0\\n    -handles 0\\n    -pivots 0\\n    -textures 0\\n    -strokes 0\\n    -motionTrails 0\\n    -clipGhosts 0\\n    -greasePencils 0\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 1874\\n    -height 1056\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t\t\"modelPanel -edit -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 0\\n    -headsUpDisplay 1\\n    -holdOuts 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 0\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 1\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 32768\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -depthOfFieldPreview 1\\n    -maxConstantTransparency 1\\n    -rendererName \\\"vp2Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -controllers 0\\n    -nurbsCurves 0\\n    -nurbsSurfaces 0\\n    -polymeshes 1\\n    -subdivSurfaces 0\\n    -planes 0\\n    -lights 0\\n    -cameras 0\\n    -controlVertices 0\\n    -hulls 0\\n    -grid 0\\n    -imagePlane 0\\n    -joints 0\\n    -ikHandles 0\\n    -deformers 0\\n    -dynamics 0\\n    -particleInstancers 0\\n    -fluids 0\\n    -hairSystems 0\\n    -follicles 0\\n    -nCloths 0\\n    -nParticles 0\\n    -nRigids 0\\n    -dynamicConstraints 0\\n    -locators 0\\n    -manipulators 1\\n    -pluginShapes 0\\n    -dimensions 0\\n    -handles 0\\n    -pivots 0\\n    -textures 0\\n    -strokes 0\\n    -motionTrails 0\\n    -clipGhosts 0\\n    -greasePencils 0\\n    -shadows 0\\n    -captureSequenceNumber -1\\n    -width 1874\\n    -height 1056\\n    -sceneRenderFilter 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t$configName;\n\n            setNamedPanelLayout (localizedPanelLabel(\"Current Layout\"));\n        }\n\n        panelHistory -e -clear mainPanelHistory;\n        sceneUIReplacement -clear;\n\t}\n\n\ngrid -spacing 5 -size 12 -divisions 5 -displayAxes yes -displayGridLines yes -displayDivisionLines yes -displayPerspectiveLabels no -displayOrthographicLabels no -displayAxesBold yes -perspectiveLabelPosition axis -orthographicLabelPosition edge;\nviewManip -drawCompass 0 -compassAngle 0 -frontParameters \"\" -homeParameters \"\" -selectionLockParameters \"\";\n}\n");
	setAttr ".st" 3;
createNode script -n "sceneConfigurationScriptNode";
	rename -uid "4FBF2BFE-4B22-BA05-3604-01B279E932A6";
	setAttr ".b" -type "string" "playbackOptions -min 0 -max 10 -ast 0 -aet 10 ";
	setAttr ".st" 6;
createNode animLayer -n "BaseAnimation";
	rename -uid "3CF2909F-4AE3-DD5D-329C-D298CF1D65ED";
	setAttr ".ovrd" yes;
createNode animLayer -n "AnimLayer1";
	rename -uid "C3C66217-4DA0-4925-ECA2-1DBDC595BBDB";
	setAttr -s 52 ".dsm";
	setAttr -s 32 ".bnds";
	setAttr ".pref" yes;
	setAttr ".slct" yes;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1";
	rename -uid "8DAA81ED-4C80-206A-0596-5EBDA80E48DC";
	setAttr ".o" -type "double3" -0.81879208786175994 7.1755871929665975 -0.16491849573927111 ;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow_R_rotate_AnimLayer1";
	rename -uid "15006C19-40A0-1019-938C-F091ECCF31B9";
	setAttr ".o" -type "double3" 0 -2.5 50.090590022106532 ;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow1_R_rotate_AnimLayer1";
	rename -uid "DACC127E-49C0-981D-9014-C5BC101B1ACA";
	setAttr ".o" -type "double3" 0 -1.9799999999999989 0 ;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKWrist_R_rotate_AnimLayer1";
	rename -uid "18D2B6F5-4EAE-1C29-E83E-8B8DC8499BB2";
	setAttr ".o" -type "double3" 0 0.74000000000000088 0 ;
createNode animCurveTA -n "FKShoulder1_R_rotate_AnimLayer1_inputBX";
	rename -uid "7A2050F9-44C7-E0B9-E3EA-01963F28F91D";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_R_rotate_AnimLayer1_inputBY";
	rename -uid "34EA3250-4503-FE86-5A56-0D8027E4513B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  0 -15.927915448689921 5 -12.775669012268715
		 10 -15.927915448689921;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_R_rotate_AnimLayer1_inputBZ";
	rename -uid "6C907CBD-4FF5-660E-03EE-9CA397EBDDA7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  0 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotate_AnimLayer1_inputBX";
	rename -uid "4321F7B2-4F24-6A05-4610-C2849CBEB6DD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  1 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotate_AnimLayer1_inputBY";
	rename -uid "6E30422C-4CB0-BB32-4822-06BE2E2E574B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  1 -2.5 6 2.5 11 -2.5;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_R_rotate_AnimLayer1_inputBZ";
	rename -uid "83DC595E-42E4-9DBF-24CA-2DBB00434D2B";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  1 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotate_AnimLayer1_inputBX";
	rename -uid "423C2E68-41A0-BD16-F6FC-95829CAB3A0C";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotate_AnimLayer1_inputBY";
	rename -uid "18399354-492F-079D-D94D-C091F3281CF2";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  2 -2.5 7 2.5 12 -2.5;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_R_rotate_AnimLayer1_inputBZ";
	rename -uid "5802D3B3-424C-4A19-C1B0-F682DD3AEEBD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  2 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotate_AnimLayer1_inputBX";
	rename -uid "671CE677-42E2-17D9-4198-7C901EF9DD3F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  4 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotate_AnimLayer1_inputBY";
	rename -uid "CC21B32D-491E-8437-B460-35BFA105075A";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  4 -2.5 9 2.5 14 -2.5;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKWrist_R_rotate_AnimLayer1_inputBZ";
	rename -uid "000AD5DF-416C-2642-E9D2-BC9C95BD6BC0";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr ".ktv[0]"  4 0;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1";
	rename -uid "2C1B98F7-4DAB-869C-A6F7-078B1C0B1F0A";
	setAttr ".o" -type "double3" -0.80773869967510636 20.503205330702869 -0.16066477663967832 ;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow_L_rotate_AnimLayer1";
	rename -uid "F9395515-4D83-3EDA-341B-2B986D69F525";
	setAttr ".o" -type "double3" 0 -0.74591996856710174 45.05053103976055 ;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKElbow1_L_rotate_AnimLayer1";
	rename -uid "84106310-476F-466B-F3AB-AFB0707DC706";
	setAttr ".o" -type "double3" 0 0.7459199970726863 0 ;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:FKWrist_L_rotate_AnimLayer1";
	rename -uid "1AB53516-4C3D-0DA6-D4CB-3BA37BD1F0EE";
	setAttr ".o" -type "double3" 0 2.5199999562118909 0 ;
createNode animCurveTA -n "FKWrist_L_rotate_AnimLayer1_inputBY";
	rename -uid "99C4C07F-40AA-9AEC-6CFE-72864D711BBA";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  6 -2.5199999277063063 11 2.5199999562118909
		 16 -2.5199999277063063;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKShoulder1_L_rotate_AnimLayer1_inputBY";
	rename -uid "A7ECC69D-4695-3147-3241-CABC65424051";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  2 -2.5199999277063094 7 2.5199999562118904
		 12 -2.5199999277063094;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow_L_rotate_AnimLayer1_inputBY";
	rename -uid "1CB60B40-4DD7-F693-FEEB-86A2CB8443B9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  3 -2.5199999277063063 8 2.5199999562118909
		 13 -2.5199999277063063;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animCurveTA -n "FKElbow1_L_rotate_AnimLayer1_inputBY";
	rename -uid "EC239C75-4A99-793E-DF75-BE9715262323";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 3 ".ktv[0:2]"  4 -2.5199999277063063 9 2.5199999562118909
		 14 -2.5199999277063063;
	setAttr ".pre" 4;
	setAttr ".pst" 4;
createNode animBlendNodeAdditiveDL -n "Sid_Rig:IKLeg_R_translateX_AnimLayer1";
	rename -uid "8E6E1BFE-440F-38C0-9BEB-A4B3026FAC1E";
createNode animBlendNodeAdditiveDL -n "Sid_Rig:IKLeg_R_translateY_AnimLayer1";
	rename -uid "89F9C290-4630-1BF9-3CAB-0A97E9CF7D01";
createNode animBlendNodeAdditiveDL -n "Sid_Rig:IKLeg_R_translateZ_AnimLayer1";
	rename -uid "5428086A-48E2-07BB-6B9D-318E773EEB50";
	setAttr ".o" 4.1566612516171624;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:IKLeg_R_rotate_AnimLayer1";
	rename -uid "25FCF804-4634-131E-0C12-C7A77B612FC5";
	setAttr ".o" -type "double3" -7.3224101209077093 12.38091466521024 35.830092648313666 ;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_toe_AnimLayer1";
	rename -uid "07272B5A-44F6-5687-A490-25AA0DE49544";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_roll_AnimLayer1";
	rename -uid "5035E8F8-4C57-10A1-9FC8-A2BB3E07EDDA";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_rollAngle_AnimLayer1";
	rename -uid "AE081D82-4506-C94A-F107-5795FC52CC2E";
	setAttr ".o" 25;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_stretchy_AnimLayer1";
	rename -uid "8592D003-489F-4D44-0EF1-038E5D040632";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_antiPop_AnimLayer1";
	rename -uid "9D3FB09C-46DE-347D-3C67-998CFD30855B";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_Lenght1_AnimLayer1";
	rename -uid "3574C46C-440D-EF23-808C-1393AB44A8B8";
	setAttr ".o" 1;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_Lenght2_AnimLayer1";
	rename -uid "B637154E-4E76-631A-06ED-838450319845";
	setAttr ".o" 1;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_R_volume_AnimLayer1";
	rename -uid "B6FF3675-4707-9D7F-F7B9-8786C8F7C9BE";
	setAttr ".o" 10;
createNode animBlendNodeAdditiveDL -n "Sid_Rig:IKLeg_L_translateX_AnimLayer1";
	rename -uid "A02687DD-458D-BCFD-0A81-1695F411CA09";
	setAttr ".o" -1.6405599818412155;
createNode animBlendNodeAdditiveDL -n "Sid_Rig:IKLeg_L_translateY_AnimLayer1";
	rename -uid "442656EA-4DA4-9067-D8D4-5BA635EEAD51";
	setAttr ".o" -0.064837783875117516;
createNode animBlendNodeAdditiveDL -n "Sid_Rig:IKLeg_L_translateZ_AnimLayer1";
	rename -uid "E55DAA9C-4160-7653-B68C-1E8B26B0F335";
	setAttr ".o" -3.5996495958424868;
createNode animBlendNodeAdditiveRotation -n "Sid_Rig:IKLeg_L_rotate_AnimLayer1";
	rename -uid "4088A4D9-47F9-B3C8-B317-0EA18183853F";
	setAttr ".o" -type "double3" -5.2885949324867054 -7.3486815339491853 -45.869423301413185 ;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_toe_AnimLayer1";
	rename -uid "F3C7660E-44AD-C8A9-5464-DE9E1A8A3870";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_roll_AnimLayer1";
	rename -uid "A60F1EC6-4B04-E13B-4C8A-6BB5C85EFCFF";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_rollAngle_AnimLayer1";
	rename -uid "D91F0426-4F73-7C78-BEA4-8493044127A4";
	setAttr ".o" 25;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_stretchy_AnimLayer1";
	rename -uid "EE481FCB-42F0-2667-0A4D-6CA97073BBFE";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_antiPop_AnimLayer1";
	rename -uid "F9986BD6-421D-9D19-CEB7-649342836DA2";
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_Lenght1_AnimLayer1";
	rename -uid "4EF03819-4121-65D6-7059-43B3C5F137E5";
	setAttr ".o" 1;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_Lenght2_AnimLayer1";
	rename -uid "3C19ED87-4E29-CABA-9AEB-37B750F612F0";
	setAttr ".o" 1;
createNode animBlendNodeAdditive -n "Sid_Rig:IKLeg_L_volume_AnimLayer1";
	rename -uid "CB2C742B-4CF9-F3B2-2525-C389F04D9EFE";
	setAttr ".o" 10;
createNode animCurveTL -n "IKLeg_L_translateX_AnimLayer1_inputB";
	rename -uid "907D9879-4E52-7707-A882-E8813B1729C9";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTL -n "IKLeg_L_translateY_AnimLayer1_inputB";
	rename -uid "C87F79F5-4C41-7471-C6FD-908444E7C0A8";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTL -n "IKLeg_L_translateZ_AnimLayer1_inputB";
	rename -uid "E6C1B496-4778-908C-157B-00850AD69FAD";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTA -n "IKLeg_L_rotate_AnimLayer1_inputBX";
	rename -uid "E9F31900-45DA-D855-8CC3-9CABB1DD640F";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
createNode animCurveTA -n "IKLeg_L_rotate_AnimLayer1_inputBY";
	rename -uid "18E6C92D-4B87-2843-D55F-648D88FF69F6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
createNode animCurveTA -n "IKLeg_L_rotate_AnimLayer1_inputBZ";
	rename -uid "86F11009-4FBC-0715-FD52-B683DE446E03";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 0 10 0;
createNode animCurveTU -n "IKLeg_L_toe_AnimLayer1_inputB";
	rename -uid "1D682CBE-4481-C725-B776-F48C963F85E6";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTU -n "IKLeg_L_roll_AnimLayer1_inputB";
	rename -uid "579F73B3-4414-811E-4DAB-6F8CF5CD2CBB";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTU -n "IKLeg_L_rollAngle_AnimLayer1_inputB";
	rename -uid "27171CAB-43B5-532E-908E-54B1025D62F5";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTU -n "IKLeg_L_stretchy_AnimLayer1_inputB";
	rename -uid "186AB6F2-4F37-E317-5F9F-78976F429CA3";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTU -n "IKLeg_L_antiPop_AnimLayer1_inputB";
	rename -uid "4F3CA272-4974-58E4-55CF-2282FA3E8D27";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTU -n "IKLeg_L_Lenght1_AnimLayer1_inputB";
	rename -uid "148D4C79-4A0D-9424-74F9-B38B8BB29ECF";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTU -n "IKLeg_L_Lenght2_AnimLayer1_inputB";
	rename -uid "67487F3A-48DA-B382-C1CF-07A50FF947DE";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode animCurveTU -n "IKLeg_L_volume_AnimLayer1_inputB";
	rename -uid "0FA9F821-4DE9-C519-E1E3-CF8CFF17FBB7";
	setAttr ".tan" 18;
	setAttr ".wgt" no;
	setAttr -s 6 ".ktv[0:5]"  0 0 2 0 4 0 6 0 8 0 10 0;
createNode polyDisc -n "polyDisc1";
	rename -uid "D0E9E6D4-4171-A61B-E871-4EA9E683F1BF";
createNode lambert -n "lambert2";
	rename -uid "90F42CC1-4CB3-9DD2-5738-92A6D54760C6";
createNode shadingEngine -n "lambert2SG";
	rename -uid "311AB5CF-4935-DA43-2ADA-EEAA16F7746A";
	setAttr ".ihi" 0;
	setAttr -s 2 ".dsm";
	setAttr ".ro" yes;
createNode materialInfo -n "materialInfo1";
	rename -uid "33EC6A20-429A-C2CE-6E78-6F8A7DD013A7";
createNode projection -n "projection1";
	rename -uid "C694B2CE-4F62-A450-E898-53A532C92922";
	setAttr ".vt1" -type "float2" 0.5 1.9442916 ;
	setAttr ".vt2" -type "float2" 0.5 1.9442916 ;
	setAttr ".vt3" -type "float2" 0.5 1.9442916 ;
createNode checker -n "checker1";
	rename -uid "9C24FED8-4102-6B78-162B-AA94C78950E6";
	setAttr ".c1" -type "float3" 0.38372093 0.38372093 0.38372093 ;
	setAttr ".c2" -type "float3" 0.30232558 0.30232558 0.30232558 ;
createNode place2dTexture -n "place2dTexture1";
	rename -uid "E459BA90-40D1-840C-9D35-4180AA9949C2";
	setAttr ".rf" 90;
	setAttr ".re" -type "float2" 4 4 ;
createNode animCurveTL -n "place3dTexture1_translateZ";
	rename -uid "69A7594C-4E60-7217-22AC-CA8483B2600D";
	setAttr ".tan" 2;
	setAttr ".wgt" no;
	setAttr -s 2 ".ktv[0:1]"  0 100 10 -200;
createNode polyCube -n "polyCube1";
	rename -uid "81C7396A-4A04-3FB6-D573-53B0348C4CC3";
	setAttr ".cuv" 4;
select -ne :time1;
	setAttr ".o" 1;
	setAttr ".unw" 1;
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
connectAttr "FKHead_M_rotateX.o" "Sid_RigRN.phl[31]";
connectAttr "FKHead_M_rotateY.o" "Sid_RigRN.phl[32]";
connectAttr "FKHead_M_rotateZ.o" "Sid_RigRN.phl[33]";
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
connectAttr "Gorro_Ctrl_rotateX.o" "Sid_RigRN.phl[57]";
connectAttr "Gorro_Ctrl_rotateY.o" "Sid_RigRN.phl[58]";
connectAttr "Gorro_Ctrl_rotateZ.o" "Sid_RigRN.phl[59]";
connectAttr "FKShoulder_R_rotateX.o" "Sid_RigRN.phl[60]";
connectAttr "FKShoulder_R_rotateY.o" "Sid_RigRN.phl[61]";
connectAttr "FKShoulder_R_rotateZ.o" "Sid_RigRN.phl[62]";
connectAttr "Sid_RigRN.phl[63]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.ox" "Sid_RigRN.phl[64]";
connectAttr "Sid_RigRN.phl[65]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.oy" "Sid_RigRN.phl[66]";
connectAttr "Sid_RigRN.phl[67]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.oz" "Sid_RigRN.phl[68]";
connectAttr "Sid_RigRN.phl[69]" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[70]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_AnimLayer1.ox" "Sid_RigRN.phl[71]";
connectAttr "Sid_RigRN.phl[72]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_AnimLayer1.oy" "Sid_RigRN.phl[73]";
connectAttr "Sid_RigRN.phl[74]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_R_rotate_AnimLayer1.oz" "Sid_RigRN.phl[75]";
connectAttr "Sid_RigRN.phl[76]" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[77]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.ox" "Sid_RigRN.phl[78]";
connectAttr "Sid_RigRN.phl[79]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.oy" "Sid_RigRN.phl[80]";
connectAttr "Sid_RigRN.phl[81]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.oz" "Sid_RigRN.phl[82]";
connectAttr "Sid_RigRN.phl[83]" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[84]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_AnimLayer1.ox" "Sid_RigRN.phl[85]";
connectAttr "Sid_RigRN.phl[86]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_AnimLayer1.oy" "Sid_RigRN.phl[87]";
connectAttr "Sid_RigRN.phl[88]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_R_rotate_AnimLayer1.oz" "Sid_RigRN.phl[89]";
connectAttr "Sid_RigRN.phl[90]" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.ro";
connectAttr "FKShoulder_L_rotateX.o" "Sid_RigRN.phl[91]";
connectAttr "FKShoulder_L_rotateY.o" "Sid_RigRN.phl[92]";
connectAttr "FKShoulder_L_rotateZ.o" "Sid_RigRN.phl[93]";
connectAttr "Sid_RigRN.phl[94]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.ox" "Sid_RigRN.phl[95]";
connectAttr "Sid_RigRN.phl[96]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.oy" "Sid_RigRN.phl[97]";
connectAttr "Sid_RigRN.phl[98]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.oz" "Sid_RigRN.phl[99]";
connectAttr "Sid_RigRN.phl[100]" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[101]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_AnimLayer1.ox" "Sid_RigRN.phl[102]";
connectAttr "Sid_RigRN.phl[103]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_AnimLayer1.oy" "Sid_RigRN.phl[104]";
connectAttr "Sid_RigRN.phl[105]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow_L_rotate_AnimLayer1.oz" "Sid_RigRN.phl[106]";
connectAttr "Sid_RigRN.phl[107]" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[108]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.ox" "Sid_RigRN.phl[109]";
connectAttr "Sid_RigRN.phl[110]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.oy" "Sid_RigRN.phl[111]";
connectAttr "Sid_RigRN.phl[112]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.oz" "Sid_RigRN.phl[113]";
connectAttr "Sid_RigRN.phl[114]" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[115]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_AnimLayer1.ox" "Sid_RigRN.phl[116]";
connectAttr "Sid_RigRN.phl[117]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_AnimLayer1.oy" "Sid_RigRN.phl[118]";
connectAttr "Sid_RigRN.phl[119]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:FKWrist_L_rotate_AnimLayer1.oz" "Sid_RigRN.phl[120]";
connectAttr "Sid_RigRN.phl[121]" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.ro";
connectAttr "FKMiddleFinger1_R_rotateX.o" "Sid_RigRN.phl[122]";
connectAttr "FKMiddleFinger1_R_rotateY.o" "Sid_RigRN.phl[123]";
connectAttr "FKMiddleFinger1_R_rotateZ.o" "Sid_RigRN.phl[124]";
connectAttr "FKMiddleFinger2_R_rotateX.o" "Sid_RigRN.phl[125]";
connectAttr "FKMiddleFinger2_R_rotateY.o" "Sid_RigRN.phl[126]";
connectAttr "FKMiddleFinger2_R_rotateZ.o" "Sid_RigRN.phl[127]";
connectAttr "FKMiddleFinger3_R_rotateX.o" "Sid_RigRN.phl[128]";
connectAttr "FKMiddleFinger3_R_rotateY.o" "Sid_RigRN.phl[129]";
connectAttr "FKMiddleFinger3_R_rotateZ.o" "Sid_RigRN.phl[130]";
connectAttr "FKThumbFinger1_R_rotateX.o" "Sid_RigRN.phl[131]";
connectAttr "FKThumbFinger1_R_rotateY.o" "Sid_RigRN.phl[132]";
connectAttr "FKThumbFinger1_R_rotateZ.o" "Sid_RigRN.phl[133]";
connectAttr "FKThumbFinger2_R_rotateX.o" "Sid_RigRN.phl[134]";
connectAttr "FKThumbFinger2_R_rotateY.o" "Sid_RigRN.phl[135]";
connectAttr "FKThumbFinger2_R_rotateZ.o" "Sid_RigRN.phl[136]";
connectAttr "FKThumbFinger3_R_rotateX.o" "Sid_RigRN.phl[137]";
connectAttr "FKThumbFinger3_R_rotateY.o" "Sid_RigRN.phl[138]";
connectAttr "FKThumbFinger3_R_rotateZ.o" "Sid_RigRN.phl[139]";
connectAttr "FKIndexFinger1_R_rotateX.o" "Sid_RigRN.phl[140]";
connectAttr "FKIndexFinger1_R_rotateY.o" "Sid_RigRN.phl[141]";
connectAttr "FKIndexFinger1_R_rotateZ.o" "Sid_RigRN.phl[142]";
connectAttr "FKIndexFinger2_R_rotateX.o" "Sid_RigRN.phl[143]";
connectAttr "FKIndexFinger2_R_rotateY.o" "Sid_RigRN.phl[144]";
connectAttr "FKIndexFinger2_R_rotateZ.o" "Sid_RigRN.phl[145]";
connectAttr "FKIndexFinger3_R_rotateX.o" "Sid_RigRN.phl[146]";
connectAttr "FKIndexFinger3_R_rotateY.o" "Sid_RigRN.phl[147]";
connectAttr "FKIndexFinger3_R_rotateZ.o" "Sid_RigRN.phl[148]";
connectAttr "FKPinkyFinger1_R_rotateX.o" "Sid_RigRN.phl[149]";
connectAttr "FKPinkyFinger1_R_rotateY.o" "Sid_RigRN.phl[150]";
connectAttr "FKPinkyFinger1_R_rotateZ.o" "Sid_RigRN.phl[151]";
connectAttr "FKPinkyFinger2_R_rotateX.o" "Sid_RigRN.phl[152]";
connectAttr "FKPinkyFinger2_R_rotateY.o" "Sid_RigRN.phl[153]";
connectAttr "FKPinkyFinger2_R_rotateZ.o" "Sid_RigRN.phl[154]";
connectAttr "FKPinkyFinger3_R_rotateX.o" "Sid_RigRN.phl[155]";
connectAttr "FKPinkyFinger3_R_rotateY.o" "Sid_RigRN.phl[156]";
connectAttr "FKPinkyFinger3_R_rotateZ.o" "Sid_RigRN.phl[157]";
connectAttr "FKSpine1_M_uiTreatment.o" "Sid_RigRN.phl[158]";
connectAttr "FKSpine1_M_translateX.o" "Sid_RigRN.phl[159]";
connectAttr "FKSpine1_M_translateY.o" "Sid_RigRN.phl[160]";
connectAttr "FKSpine1_M_translateZ.o" "Sid_RigRN.phl[161]";
connectAttr "FKSpine1_M_rotateX.o" "Sid_RigRN.phl[162]";
connectAttr "FKSpine1_M_rotateY.o" "Sid_RigRN.phl[163]";
connectAttr "FKSpine1_M_rotateZ.o" "Sid_RigRN.phl[164]";
connectAttr "FKChest_M_translateX.o" "Sid_RigRN.phl[165]";
connectAttr "FKChest_M_translateY.o" "Sid_RigRN.phl[166]";
connectAttr "FKChest_M_translateZ.o" "Sid_RigRN.phl[167]";
connectAttr "FKChest_M_rotateX.o" "Sid_RigRN.phl[168]";
connectAttr "FKChest_M_rotateY.o" "Sid_RigRN.phl[169]";
connectAttr "FKChest_M_rotateZ.o" "Sid_RigRN.phl[170]";
connectAttr "FKRoot_M_translateX.o" "Sid_RigRN.phl[171]";
connectAttr "FKRoot_M_translateY.o" "Sid_RigRN.phl[172]";
connectAttr "FKRoot_M_translateZ.o" "Sid_RigRN.phl[173]";
connectAttr "FKRoot_M_rotateX.o" "Sid_RigRN.phl[174]";
connectAttr "FKRoot_M_rotateY.o" "Sid_RigRN.phl[175]";
connectAttr "FKRoot_M_rotateZ.o" "Sid_RigRN.phl[176]";
connectAttr "FKToes_L_rotateX.o" "Sid_RigRN.phl[177]";
connectAttr "FKToes_L_rotateY.o" "Sid_RigRN.phl[178]";
connectAttr "FKToes_L_rotateZ.o" "Sid_RigRN.phl[179]";
connectAttr "FKMiddleFinger1_L_rotateX.o" "Sid_RigRN.phl[180]";
connectAttr "FKMiddleFinger1_L_rotateY.o" "Sid_RigRN.phl[181]";
connectAttr "FKMiddleFinger1_L_rotateZ.o" "Sid_RigRN.phl[182]";
connectAttr "FKMiddleFinger2_L_rotateX.o" "Sid_RigRN.phl[183]";
connectAttr "FKMiddleFinger2_L_rotateY.o" "Sid_RigRN.phl[184]";
connectAttr "FKMiddleFinger2_L_rotateZ.o" "Sid_RigRN.phl[185]";
connectAttr "FKMiddleFinger3_L_rotateX.o" "Sid_RigRN.phl[186]";
connectAttr "FKMiddleFinger3_L_rotateY.o" "Sid_RigRN.phl[187]";
connectAttr "FKMiddleFinger3_L_rotateZ.o" "Sid_RigRN.phl[188]";
connectAttr "FKThumbFinger1_L_rotateX.o" "Sid_RigRN.phl[189]";
connectAttr "FKThumbFinger1_L_rotateY.o" "Sid_RigRN.phl[190]";
connectAttr "FKThumbFinger1_L_rotateZ.o" "Sid_RigRN.phl[191]";
connectAttr "FKThumbFinger2_L_rotateX.o" "Sid_RigRN.phl[192]";
connectAttr "FKThumbFinger2_L_rotateY.o" "Sid_RigRN.phl[193]";
connectAttr "FKThumbFinger2_L_rotateZ.o" "Sid_RigRN.phl[194]";
connectAttr "FKThumbFinger3_L_rotateX.o" "Sid_RigRN.phl[195]";
connectAttr "FKThumbFinger3_L_rotateY.o" "Sid_RigRN.phl[196]";
connectAttr "FKThumbFinger3_L_rotateZ.o" "Sid_RigRN.phl[197]";
connectAttr "FKIndexFinger1_L_rotateX.o" "Sid_RigRN.phl[198]";
connectAttr "FKIndexFinger1_L_rotateY.o" "Sid_RigRN.phl[199]";
connectAttr "FKIndexFinger1_L_rotateZ.o" "Sid_RigRN.phl[200]";
connectAttr "FKIndexFinger2_L_rotateX.o" "Sid_RigRN.phl[201]";
connectAttr "FKIndexFinger2_L_rotateY.o" "Sid_RigRN.phl[202]";
connectAttr "FKIndexFinger2_L_rotateZ.o" "Sid_RigRN.phl[203]";
connectAttr "FKIndexFinger3_L_rotateX.o" "Sid_RigRN.phl[204]";
connectAttr "FKIndexFinger3_L_rotateY.o" "Sid_RigRN.phl[205]";
connectAttr "FKIndexFinger3_L_rotateZ.o" "Sid_RigRN.phl[206]";
connectAttr "FKPinkyFinger1_L_rotateX.o" "Sid_RigRN.phl[207]";
connectAttr "FKPinkyFinger1_L_rotateY.o" "Sid_RigRN.phl[208]";
connectAttr "FKPinkyFinger1_L_rotateZ.o" "Sid_RigRN.phl[209]";
connectAttr "FKPinkyFinger2_L_rotateX.o" "Sid_RigRN.phl[210]";
connectAttr "FKPinkyFinger2_L_rotateY.o" "Sid_RigRN.phl[211]";
connectAttr "FKPinkyFinger2_L_rotateZ.o" "Sid_RigRN.phl[212]";
connectAttr "FKPinkyFinger3_L_rotateX.o" "Sid_RigRN.phl[213]";
connectAttr "FKPinkyFinger3_L_rotateY.o" "Sid_RigRN.phl[214]";
connectAttr "FKPinkyFinger3_L_rotateZ.o" "Sid_RigRN.phl[215]";
connectAttr "HipSwinger_M_rotateX.o" "Sid_RigRN.phl[216]";
connectAttr "HipSwinger_M_rotateY.o" "Sid_RigRN.phl[217]";
connectAttr "HipSwinger_M_rotateZ.o" "Sid_RigRN.phl[218]";
connectAttr "HipSwinger_M_stabilize.o" "Sid_RigRN.phl[219]";
connectAttr "Sid_RigRN.phl[220]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_translateZ_AnimLayer1.o" "Sid_RigRN.phl[221]";
connectAttr "Sid_RigRN.phl[222]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_translateX_AnimLayer1.o" "Sid_RigRN.phl[223]";
connectAttr "Sid_RigRN.phl[224]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_translateY_AnimLayer1.o" "Sid_RigRN.phl[225]";
connectAttr "Sid_RigRN.phl[226]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_rotate_AnimLayer1.oy" "Sid_RigRN.phl[227]";
connectAttr "Sid_RigRN.phl[228]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_rotate_AnimLayer1.ox" "Sid_RigRN.phl[229]";
connectAttr "Sid_RigRN.phl[230]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_rotate_AnimLayer1.oz" "Sid_RigRN.phl[231]";
connectAttr "Sid_RigRN.phl[232]" "Sid_Rig:IKLeg_R_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[233]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_toe_AnimLayer1.o" "Sid_RigRN.phl[234]";
connectAttr "Sid_RigRN.phl[235]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_rollAngle_AnimLayer1.o" "Sid_RigRN.phl[236]";
connectAttr "Sid_RigRN.phl[237]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_roll_AnimLayer1.o" "Sid_RigRN.phl[238]";
connectAttr "Sid_RigRN.phl[239]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_stretchy_AnimLayer1.o" "Sid_RigRN.phl[240]";
connectAttr "Sid_RigRN.phl[241]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_antiPop_AnimLayer1.o" "Sid_RigRN.phl[242]";
connectAttr "Sid_RigRN.phl[243]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_Lenght1_AnimLayer1.o" "Sid_RigRN.phl[244]";
connectAttr "Sid_RigRN.phl[245]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_Lenght2_AnimLayer1.o" "Sid_RigRN.phl[246]";
connectAttr "Sid_RigRN.phl[247]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_R_volume_AnimLayer1.o" "Sid_RigRN.phl[248]";
connectAttr "RollHeel_R_translateX.o" "Sid_RigRN.phl[249]";
connectAttr "RollHeel_R_translateY.o" "Sid_RigRN.phl[250]";
connectAttr "RollHeel_R_translateZ.o" "Sid_RigRN.phl[251]";
connectAttr "RollHeel_R_visibility.o" "Sid_RigRN.phl[252]";
connectAttr "RollHeel_R_rotateX.o" "Sid_RigRN.phl[253]";
connectAttr "RollHeel_R_rotateY.o" "Sid_RigRN.phl[254]";
connectAttr "RollHeel_R_rotateZ.o" "Sid_RigRN.phl[255]";
connectAttr "RollHeel_R_scaleX.o" "Sid_RigRN.phl[256]";
connectAttr "RollHeel_R_scaleY.o" "Sid_RigRN.phl[257]";
connectAttr "RollHeel_R_scaleZ.o" "Sid_RigRN.phl[258]";
connectAttr "RollToesEnd_R_translateX.o" "Sid_RigRN.phl[259]";
connectAttr "RollToesEnd_R_translateY.o" "Sid_RigRN.phl[260]";
connectAttr "RollToesEnd_R_translateZ.o" "Sid_RigRN.phl[261]";
connectAttr "RollToesEnd_R_visibility.o" "Sid_RigRN.phl[262]";
connectAttr "RollToesEnd_R_rotateX.o" "Sid_RigRN.phl[263]";
connectAttr "RollToesEnd_R_rotateY.o" "Sid_RigRN.phl[264]";
connectAttr "RollToesEnd_R_rotateZ.o" "Sid_RigRN.phl[265]";
connectAttr "RollToesEnd_R_scaleX.o" "Sid_RigRN.phl[266]";
connectAttr "RollToesEnd_R_scaleY.o" "Sid_RigRN.phl[267]";
connectAttr "RollToesEnd_R_scaleZ.o" "Sid_RigRN.phl[268]";
connectAttr "RollToes_R_rotateZ.o" "Sid_RigRN.phl[269]";
connectAttr "RollToes_R_rotateX.o" "Sid_RigRN.phl[270]";
connectAttr "RollToes_R_rotateY.o" "Sid_RigRN.phl[271]";
connectAttr "RollToes_R_translateX.o" "Sid_RigRN.phl[272]";
connectAttr "RollToes_R_translateY.o" "Sid_RigRN.phl[273]";
connectAttr "RollToes_R_translateZ.o" "Sid_RigRN.phl[274]";
connectAttr "RollToes_R_visibility.o" "Sid_RigRN.phl[275]";
connectAttr "RollToes_R_scaleX.o" "Sid_RigRN.phl[276]";
connectAttr "RollToes_R_scaleY.o" "Sid_RigRN.phl[277]";
connectAttr "RollToes_R_scaleZ.o" "Sid_RigRN.phl[278]";
connectAttr "PoleLeg_R_translateX.o" "Sid_RigRN.phl[279]";
connectAttr "PoleLeg_R_translateY.o" "Sid_RigRN.phl[280]";
connectAttr "PoleLeg_R_translateZ.o" "Sid_RigRN.phl[281]";
connectAttr "PoleLeg_R_follow.o" "Sid_RigRN.phl[282]";
connectAttr "PoleLeg_R_lock.o" "Sid_RigRN.phl[283]";
connectAttr "Sid_RigRN.phl[284]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_translateX_AnimLayer1.o" "Sid_RigRN.phl[285]";
connectAttr "Sid_RigRN.phl[286]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_translateY_AnimLayer1.o" "Sid_RigRN.phl[287]";
connectAttr "Sid_RigRN.phl[288]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_translateZ_AnimLayer1.o" "Sid_RigRN.phl[289]";
connectAttr "Sid_RigRN.phl[290]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_rotate_AnimLayer1.oy" "Sid_RigRN.phl[291]";
connectAttr "Sid_RigRN.phl[292]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_rotate_AnimLayer1.ox" "Sid_RigRN.phl[293]";
connectAttr "Sid_RigRN.phl[294]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_rotate_AnimLayer1.oz" "Sid_RigRN.phl[295]";
connectAttr "Sid_RigRN.phl[296]" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.ro";
connectAttr "Sid_RigRN.phl[297]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_toe_AnimLayer1.o" "Sid_RigRN.phl[298]";
connectAttr "Sid_RigRN.phl[299]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_rollAngle_AnimLayer1.o" "Sid_RigRN.phl[300]";
connectAttr "Sid_RigRN.phl[301]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_roll_AnimLayer1.o" "Sid_RigRN.phl[302]";
connectAttr "Sid_RigRN.phl[303]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_stretchy_AnimLayer1.o" "Sid_RigRN.phl[304]";
connectAttr "Sid_RigRN.phl[305]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_antiPop_AnimLayer1.o" "Sid_RigRN.phl[306]";
connectAttr "Sid_RigRN.phl[307]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_Lenght1_AnimLayer1.o" "Sid_RigRN.phl[308]";
connectAttr "Sid_RigRN.phl[309]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_Lenght2_AnimLayer1.o" "Sid_RigRN.phl[310]";
connectAttr "Sid_RigRN.phl[311]" "AnimLayer1.dsm" -na;
connectAttr "Sid_Rig:IKLeg_L_volume_AnimLayer1.o" "Sid_RigRN.phl[312]";
connectAttr "RollHeel_L_translateX.o" "Sid_RigRN.phl[313]";
connectAttr "RollHeel_L_translateY.o" "Sid_RigRN.phl[314]";
connectAttr "RollHeel_L_translateZ.o" "Sid_RigRN.phl[315]";
connectAttr "RollHeel_L_visibility.o" "Sid_RigRN.phl[316]";
connectAttr "RollHeel_L_rotateX.o" "Sid_RigRN.phl[317]";
connectAttr "RollHeel_L_rotateY.o" "Sid_RigRN.phl[318]";
connectAttr "RollHeel_L_rotateZ.o" "Sid_RigRN.phl[319]";
connectAttr "RollHeel_L_scaleX.o" "Sid_RigRN.phl[320]";
connectAttr "RollHeel_L_scaleY.o" "Sid_RigRN.phl[321]";
connectAttr "RollHeel_L_scaleZ.o" "Sid_RigRN.phl[322]";
connectAttr "RollToesEnd_L_translateX.o" "Sid_RigRN.phl[323]";
connectAttr "RollToesEnd_L_translateY.o" "Sid_RigRN.phl[324]";
connectAttr "RollToesEnd_L_translateZ.o" "Sid_RigRN.phl[325]";
connectAttr "RollToesEnd_L_visibility.o" "Sid_RigRN.phl[326]";
connectAttr "RollToesEnd_L_rotateX.o" "Sid_RigRN.phl[327]";
connectAttr "RollToesEnd_L_rotateY.o" "Sid_RigRN.phl[328]";
connectAttr "RollToesEnd_L_rotateZ.o" "Sid_RigRN.phl[329]";
connectAttr "RollToesEnd_L_scaleX.o" "Sid_RigRN.phl[330]";
connectAttr "RollToesEnd_L_scaleY.o" "Sid_RigRN.phl[331]";
connectAttr "RollToesEnd_L_scaleZ.o" "Sid_RigRN.phl[332]";
connectAttr "RollToes_L_rotateZ.o" "Sid_RigRN.phl[333]";
connectAttr "RollToes_L_rotateX.o" "Sid_RigRN.phl[334]";
connectAttr "RollToes_L_rotateY.o" "Sid_RigRN.phl[335]";
connectAttr "RollToes_L_translateX.o" "Sid_RigRN.phl[336]";
connectAttr "RollToes_L_translateY.o" "Sid_RigRN.phl[337]";
connectAttr "RollToes_L_translateZ.o" "Sid_RigRN.phl[338]";
connectAttr "RollToes_L_visibility.o" "Sid_RigRN.phl[339]";
connectAttr "RollToes_L_scaleX.o" "Sid_RigRN.phl[340]";
connectAttr "RollToes_L_scaleY.o" "Sid_RigRN.phl[341]";
connectAttr "RollToes_L_scaleZ.o" "Sid_RigRN.phl[342]";
connectAttr "PoleLeg_L_translateX.o" "Sid_RigRN.phl[343]";
connectAttr "PoleLeg_L_translateY.o" "Sid_RigRN.phl[344]";
connectAttr "PoleLeg_L_translateZ.o" "Sid_RigRN.phl[345]";
connectAttr "PoleLeg_L_follow.o" "Sid_RigRN.phl[346]";
connectAttr "PoleLeg_L_lock.o" "Sid_RigRN.phl[347]";
connectAttr "FKIKLeg_R_FKIKBlend.o" "Sid_RigRN.phl[348]";
connectAttr "FKIKLeg_R_IKVis.o" "Sid_RigRN.phl[349]";
connectAttr "FKIKLeg_R_FKVis.o" "Sid_RigRN.phl[350]";
connectAttr "FKIKArm_R_FKIKBlend.o" "Sid_RigRN.phl[351]";
connectAttr "FKIKArm_R_IKVis.o" "Sid_RigRN.phl[352]";
connectAttr "FKIKArm_R_FKVis.o" "Sid_RigRN.phl[353]";
connectAttr "FKIKSpine_M_FKIKBlend.o" "Sid_RigRN.phl[354]";
connectAttr "FKIKSpine_M_IKVis.o" "Sid_RigRN.phl[355]";
connectAttr "FKIKSpine_M_FKVis.o" "Sid_RigRN.phl[356]";
connectAttr "FKIKLeg_L_FKIKBlend.o" "Sid_RigRN.phl[357]";
connectAttr "FKIKLeg_L_IKVis.o" "Sid_RigRN.phl[358]";
connectAttr "FKIKLeg_L_FKVis.o" "Sid_RigRN.phl[359]";
connectAttr "FKIKArm_L_FKIKBlend.o" "Sid_RigRN.phl[360]";
connectAttr "FKIKArm_L_IKVis.o" "Sid_RigRN.phl[361]";
connectAttr "FKIKArm_L_FKVis.o" "Sid_RigRN.phl[362]";
connectAttr "RootX_M_rotateX.o" "Sid_RigRN.phl[363]";
connectAttr "RootX_M_rotateY.o" "Sid_RigRN.phl[364]";
connectAttr "RootX_M_rotateZ.o" "Sid_RigRN.phl[365]";
connectAttr "RootX_M_legLock.o" "Sid_RigRN.phl[366]";
connectAttr "RootX_M_CenterBtwFeet.o" "Sid_RigRN.phl[367]";
connectAttr "RootX_M_translateY.o" "Sid_RigRN.phl[368]";
connectAttr "RootX_M_translateX.o" "Sid_RigRN.phl[369]";
connectAttr "RootX_M_translateZ.o" "Sid_RigRN.phl[370]";
connectAttr "Fingers_R_indexCurl.o" "Sid_RigRN.phl[371]";
connectAttr "Fingers_R_middleCurl.o" "Sid_RigRN.phl[372]";
connectAttr "Fingers_R_pinkyCurl.o" "Sid_RigRN.phl[373]";
connectAttr "Fingers_R_thumbCurl.o" "Sid_RigRN.phl[374]";
connectAttr "Fingers_R_spread.o" "Sid_RigRN.phl[375]";
connectAttr "Fingers_L_indexCurl.o" "Sid_RigRN.phl[376]";
connectAttr "Fingers_L_middleCurl.o" "Sid_RigRN.phl[377]";
connectAttr "Fingers_L_pinkyCurl.o" "Sid_RigRN.phl[378]";
connectAttr "Fingers_L_thumbCurl.o" "Sid_RigRN.phl[379]";
connectAttr "Fingers_L_spread.o" "Sid_RigRN.phl[380]";
connectAttr "polyDisc1.output" "pDiscShape1.i";
connectAttr "place3dTexture1_translateZ.o" "place3dTexture1.tz";
connectAttr "polyCube1.out" "pCubeShape1.i";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" "lambert2SG.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" "lambert2SG.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr "pairBlend1_inTranslateX1.o" "pairBlend1.itx1";
connectAttr "pairBlend1_inTranslateY1.o" "pairBlend1.ity1";
connectAttr "pairBlend1_inTranslateZ1.o" "pairBlend1.itz1";
connectAttr "pairBlend1_inRotateX1.o" "pairBlend1.irx1";
connectAttr "pairBlend1_inRotateY1.o" "pairBlend1.iry1";
connectAttr "pairBlend1_inRotateZ1.o" "pairBlend1.irz1";
connectAttr "AnimLayer1.sl" "BaseAnimation.chsl[0]";
connectAttr "AnimLayer1.play" "BaseAnimation.cdly[0]";
connectAttr "BaseAnimation.csol" "AnimLayer1.sslo";
connectAttr "BaseAnimation.fgwt" "AnimLayer1.pwth";
connectAttr "BaseAnimation.omte" "AnimLayer1.pmte";
connectAttr "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.msg" "AnimLayer1.bnds[3]";
connectAttr "Sid_Rig:FKElbow_R_rotate_AnimLayer1.msg" "AnimLayer1.bnds[7]";
connectAttr "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.msg" "AnimLayer1.bnds[11]";
connectAttr "Sid_Rig:FKWrist_R_rotate_AnimLayer1.msg" "AnimLayer1.bnds[15]";
connectAttr "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.msg" "AnimLayer1.bnds[19]";
connectAttr "Sid_Rig:FKElbow_L_rotate_AnimLayer1.msg" "AnimLayer1.bnds[23]";
connectAttr "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.msg" "AnimLayer1.bnds[27]";
connectAttr "Sid_Rig:FKWrist_L_rotate_AnimLayer1.msg" "AnimLayer1.bnds[31]";
connectAttr "Sid_Rig:IKLeg_R_translateX_AnimLayer1.msg" "AnimLayer1.bnds[32]";
connectAttr "Sid_Rig:IKLeg_R_translateY_AnimLayer1.msg" "AnimLayer1.bnds[33]";
connectAttr "Sid_Rig:IKLeg_R_translateZ_AnimLayer1.msg" "AnimLayer1.bnds[34]";
connectAttr "Sid_Rig:IKLeg_R_rotate_AnimLayer1.msg" "AnimLayer1.bnds[38]";
connectAttr "Sid_Rig:IKLeg_R_toe_AnimLayer1.msg" "AnimLayer1.bnds[39]";
connectAttr "Sid_Rig:IKLeg_R_roll_AnimLayer1.msg" "AnimLayer1.bnds[40]";
connectAttr "Sid_Rig:IKLeg_R_rollAngle_AnimLayer1.msg" "AnimLayer1.bnds[41]";
connectAttr "Sid_Rig:IKLeg_R_stretchy_AnimLayer1.msg" "AnimLayer1.bnds[42]";
connectAttr "Sid_Rig:IKLeg_R_antiPop_AnimLayer1.msg" "AnimLayer1.bnds[43]";
connectAttr "Sid_Rig:IKLeg_R_Lenght1_AnimLayer1.msg" "AnimLayer1.bnds[44]";
connectAttr "Sid_Rig:IKLeg_R_Lenght2_AnimLayer1.msg" "AnimLayer1.bnds[45]";
connectAttr "Sid_Rig:IKLeg_R_volume_AnimLayer1.msg" "AnimLayer1.bnds[46]";
connectAttr "Sid_Rig:IKLeg_L_translateX_AnimLayer1.msg" "AnimLayer1.bnds[47]";
connectAttr "Sid_Rig:IKLeg_L_translateY_AnimLayer1.msg" "AnimLayer1.bnds[48]";
connectAttr "Sid_Rig:IKLeg_L_translateZ_AnimLayer1.msg" "AnimLayer1.bnds[49]";
connectAttr "Sid_Rig:IKLeg_L_rotate_AnimLayer1.msg" "AnimLayer1.bnds[53]";
connectAttr "Sid_Rig:IKLeg_L_toe_AnimLayer1.msg" "AnimLayer1.bnds[54]";
connectAttr "Sid_Rig:IKLeg_L_roll_AnimLayer1.msg" "AnimLayer1.bnds[55]";
connectAttr "Sid_Rig:IKLeg_L_rollAngle_AnimLayer1.msg" "AnimLayer1.bnds[56]";
connectAttr "Sid_Rig:IKLeg_L_stretchy_AnimLayer1.msg" "AnimLayer1.bnds[57]";
connectAttr "Sid_Rig:IKLeg_L_antiPop_AnimLayer1.msg" "AnimLayer1.bnds[58]";
connectAttr "Sid_Rig:IKLeg_L_Lenght1_AnimLayer1.msg" "AnimLayer1.bnds[59]";
connectAttr "Sid_Rig:IKLeg_L_Lenght2_AnimLayer1.msg" "AnimLayer1.bnds[60]";
connectAttr "Sid_Rig:IKLeg_L_volume_AnimLayer1.msg" "AnimLayer1.bnds[61]";
connectAttr "FKShoulder1_R_rotateX.o" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.iax"
		;
connectAttr "FKShoulder1_R_rotateY.o" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.iay"
		;
connectAttr "FKShoulder1_R_rotateZ.o" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.iaz"
		;
connectAttr "AnimLayer1.oram" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.wb";
connectAttr "FKShoulder1_R_rotate_AnimLayer1_inputBX.o" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.ibx"
		;
connectAttr "FKShoulder1_R_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.iby"
		;
connectAttr "FKShoulder1_R_rotate_AnimLayer1_inputBZ.o" "Sid_Rig:FKShoulder1_R_rotate_AnimLayer1.ibz"
		;
connectAttr "FKElbow_R_rotateX.o" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.iax";
connectAttr "FKElbow_R_rotateY.o" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.iay";
connectAttr "FKElbow_R_rotateZ.o" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.wb";
connectAttr "FKElbow_R_rotate_AnimLayer1_inputBX.o" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.ibx"
		;
connectAttr "FKElbow_R_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.iby"
		;
connectAttr "FKElbow_R_rotate_AnimLayer1_inputBZ.o" "Sid_Rig:FKElbow_R_rotate_AnimLayer1.ibz"
		;
connectAttr "FKElbow1_R_rotateX.o" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.iax";
connectAttr "FKElbow1_R_rotateY.o" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.iay";
connectAttr "FKElbow1_R_rotateZ.o" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.wb";
connectAttr "FKElbow1_R_rotate_AnimLayer1_inputBX.o" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.ibx"
		;
connectAttr "FKElbow1_R_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.iby"
		;
connectAttr "FKElbow1_R_rotate_AnimLayer1_inputBZ.o" "Sid_Rig:FKElbow1_R_rotate_AnimLayer1.ibz"
		;
connectAttr "FKWrist_R_rotateX.o" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.iax";
connectAttr "FKWrist_R_rotateY.o" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.iay";
connectAttr "FKWrist_R_rotateZ.o" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.wb";
connectAttr "FKWrist_R_rotate_AnimLayer1_inputBX.o" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.ibx"
		;
connectAttr "FKWrist_R_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.iby"
		;
connectAttr "FKWrist_R_rotate_AnimLayer1_inputBZ.o" "Sid_Rig:FKWrist_R_rotate_AnimLayer1.ibz"
		;
connectAttr "FKShoulder1_L_rotateX.o" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.iax"
		;
connectAttr "FKShoulder1_L_rotateY.o" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.iay"
		;
connectAttr "FKShoulder1_L_rotateZ.o" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.iaz"
		;
connectAttr "AnimLayer1.oram" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.wb";
connectAttr "FKShoulder1_L_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKShoulder1_L_rotate_AnimLayer1.iby"
		;
connectAttr "FKElbow_L_rotateX.o" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.iax";
connectAttr "FKElbow_L_rotateY.o" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.iay";
connectAttr "FKElbow_L_rotateZ.o" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.wb";
connectAttr "FKElbow_L_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKElbow_L_rotate_AnimLayer1.iby"
		;
connectAttr "FKElbow1_L_rotateX.o" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.iax";
connectAttr "FKElbow1_L_rotateY.o" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.iay";
connectAttr "FKElbow1_L_rotateZ.o" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.wb";
connectAttr "FKElbow1_L_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKElbow1_L_rotate_AnimLayer1.iby"
		;
connectAttr "FKWrist_L_rotateX.o" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.iax";
connectAttr "FKWrist_L_rotateY.o" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.iay";
connectAttr "FKWrist_L_rotateZ.o" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.wb";
connectAttr "FKWrist_L_rotate_AnimLayer1_inputBY.o" "Sid_Rig:FKWrist_L_rotate_AnimLayer1.iby"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_translateX_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_translateX_AnimLayer1.wb";
connectAttr "IKLeg_R_translateX.o" "Sid_Rig:IKLeg_R_translateX_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_translateY_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_translateY_AnimLayer1.wb";
connectAttr "IKLeg_R_translateY.o" "Sid_Rig:IKLeg_R_translateY_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_translateZ_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_translateZ_AnimLayer1.wb";
connectAttr "IKLeg_R_translateZ.o" "Sid_Rig:IKLeg_R_translateZ_AnimLayer1.ia";
connectAttr "IKLeg_R_rotateX.o" "Sid_Rig:IKLeg_R_rotate_AnimLayer1.iax";
connectAttr "IKLeg_R_rotateY.o" "Sid_Rig:IKLeg_R_rotate_AnimLayer1.iay";
connectAttr "IKLeg_R_rotateZ.o" "Sid_Rig:IKLeg_R_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:IKLeg_R_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_rotate_AnimLayer1.wb";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_toe_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_toe_AnimLayer1.wb";
connectAttr "IKLeg_R_toe.o" "Sid_Rig:IKLeg_R_toe_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_roll_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_roll_AnimLayer1.wb";
connectAttr "IKLeg_R_roll.o" "Sid_Rig:IKLeg_R_roll_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_rollAngle_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_rollAngle_AnimLayer1.wb";
connectAttr "IKLeg_R_rollAngle.o" "Sid_Rig:IKLeg_R_rollAngle_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_stretchy_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_stretchy_AnimLayer1.wb";
connectAttr "IKLeg_R_stretchy.o" "Sid_Rig:IKLeg_R_stretchy_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_antiPop_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_antiPop_AnimLayer1.wb";
connectAttr "IKLeg_R_antiPop.o" "Sid_Rig:IKLeg_R_antiPop_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_Lenght1_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_Lenght1_AnimLayer1.wb";
connectAttr "IKLeg_R_Lenght1.o" "Sid_Rig:IKLeg_R_Lenght1_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_Lenght2_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_Lenght2_AnimLayer1.wb";
connectAttr "IKLeg_R_Lenght2.o" "Sid_Rig:IKLeg_R_Lenght2_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_R_volume_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_R_volume_AnimLayer1.wb";
connectAttr "IKLeg_R_volume.o" "Sid_Rig:IKLeg_R_volume_AnimLayer1.ia";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_translateX_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_translateX_AnimLayer1.wb";
connectAttr "IKLeg_L_translateX.o" "Sid_Rig:IKLeg_L_translateX_AnimLayer1.ia";
connectAttr "IKLeg_L_translateX_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_translateX_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_translateY_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_translateY_AnimLayer1.wb";
connectAttr "IKLeg_L_translateY.o" "Sid_Rig:IKLeg_L_translateY_AnimLayer1.ia";
connectAttr "IKLeg_L_translateY_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_translateY_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_translateZ_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_translateZ_AnimLayer1.wb";
connectAttr "IKLeg_L_translateZ.o" "Sid_Rig:IKLeg_L_translateZ_AnimLayer1.ia";
connectAttr "IKLeg_L_translateZ_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_translateZ_AnimLayer1.ib"
		;
connectAttr "IKLeg_L_rotateX.o" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.iax";
connectAttr "IKLeg_L_rotateY.o" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.iay";
connectAttr "IKLeg_L_rotateZ.o" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.iaz";
connectAttr "AnimLayer1.oram" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.acm";
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.wb";
connectAttr "IKLeg_L_rotate_AnimLayer1_inputBX.o" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.ibx"
		;
connectAttr "IKLeg_L_rotate_AnimLayer1_inputBY.o" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.iby"
		;
connectAttr "IKLeg_L_rotate_AnimLayer1_inputBZ.o" "Sid_Rig:IKLeg_L_rotate_AnimLayer1.ibz"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_toe_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_toe_AnimLayer1.wb";
connectAttr "IKLeg_L_toe.o" "Sid_Rig:IKLeg_L_toe_AnimLayer1.ia";
connectAttr "IKLeg_L_toe_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_toe_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_roll_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_roll_AnimLayer1.wb";
connectAttr "IKLeg_L_roll.o" "Sid_Rig:IKLeg_L_roll_AnimLayer1.ia";
connectAttr "IKLeg_L_roll_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_roll_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_rollAngle_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_rollAngle_AnimLayer1.wb";
connectAttr "IKLeg_L_rollAngle.o" "Sid_Rig:IKLeg_L_rollAngle_AnimLayer1.ia";
connectAttr "IKLeg_L_rollAngle_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_rollAngle_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_stretchy_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_stretchy_AnimLayer1.wb";
connectAttr "IKLeg_L_stretchy.o" "Sid_Rig:IKLeg_L_stretchy_AnimLayer1.ia";
connectAttr "IKLeg_L_stretchy_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_stretchy_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_antiPop_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_antiPop_AnimLayer1.wb";
connectAttr "IKLeg_L_antiPop.o" "Sid_Rig:IKLeg_L_antiPop_AnimLayer1.ia";
connectAttr "IKLeg_L_antiPop_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_antiPop_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_Lenght1_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_Lenght1_AnimLayer1.wb";
connectAttr "IKLeg_L_Lenght1.o" "Sid_Rig:IKLeg_L_Lenght1_AnimLayer1.ia";
connectAttr "IKLeg_L_Lenght1_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_Lenght1_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_Lenght2_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_Lenght2_AnimLayer1.wb";
connectAttr "IKLeg_L_Lenght2.o" "Sid_Rig:IKLeg_L_Lenght2_AnimLayer1.ia";
connectAttr "IKLeg_L_Lenght2_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_Lenght2_AnimLayer1.ib"
		;
connectAttr "AnimLayer1.bgwt" "Sid_Rig:IKLeg_L_volume_AnimLayer1.wa";
connectAttr "AnimLayer1.fgwt" "Sid_Rig:IKLeg_L_volume_AnimLayer1.wb";
connectAttr "IKLeg_L_volume.o" "Sid_Rig:IKLeg_L_volume_AnimLayer1.ia";
connectAttr "IKLeg_L_volume_AnimLayer1_inputB.o" "Sid_Rig:IKLeg_L_volume_AnimLayer1.ib"
		;
connectAttr "projection1.oc" "lambert2.c";
connectAttr "lambert2.oc" "lambert2SG.ss";
connectAttr "pDiscShape1.iog" "lambert2SG.dsm" -na;
connectAttr "pCubeShape1.iog" "lambert2SG.dsm" -na;
connectAttr "lambert2SG.msg" "materialInfo1.sg";
connectAttr "lambert2.msg" "materialInfo1.m";
connectAttr "projection1.msg" "materialInfo1.t" -na;
connectAttr "place3dTexture1.wim" "projection1.pm";
connectAttr "checker1.oc" "projection1.im";
connectAttr "place2dTexture1.o" "checker1.uv";
connectAttr "place2dTexture1.ofs" "checker1.fs";
connectAttr "lambert2SG.pa" ":renderPartition.st" -na;
connectAttr "lambert2.msg" ":defaultShaderList1.s" -na;
connectAttr "place3dTexture1.msg" ":defaultRenderUtilityList1.u" -na;
connectAttr "place2dTexture1.msg" ":defaultRenderUtilityList1.u" -na;
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
connectAttr "projection1.msg" ":defaultTextureList1.tx" -na;
connectAttr "checker1.msg" ":defaultTextureList1.tx" -na;
// End of Sid_Grind_A.ma
