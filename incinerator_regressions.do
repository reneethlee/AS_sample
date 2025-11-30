
//20190826 Incinerators
//06. run regression

clear

set linesize 255
set more off, permanently
set matsize 9999
cap log c


global root I:\2 USER\H103119\2 使用者資料\程式碼\慈惠\焚化爐
global data I:\2 USER\STATA
global file I:\2 USER\H103119\2 使用者資料\程式碼\慈惠
global enrol I:\2 USER\H103119\2 使用者資料\stata_data\全人口\承保檔
global death I:\2 USER\H103119\2 使用者資料\stata_data\全人口

cd "$root"

***********************************************************************************************
local step = "07"
local project = "incin"
local date = "20190911"

local now = "regression"

local today : di %td_CYND  date("$S_DATE", "DMY")
local today  = subinstr("`today'"," ","",.)
global wtitle "window manage maintitle "Running `project': `now' 15km - `today'" "
$wtitle


global log "`project'_`step'_`now'-15km3_`date'"
log using "$log"     , text replace

//--------------------------------------------
local km 15
//--------------------------------------------



if `km'==15{
qui{/*global inc - 15km*/
#delimit ;
global inc = "
Beitou
Bali
Wuri
Houli
Yongkang
Chengxi
Gangshan
Renwu
KaohCentral
KaohSouth
Tianwaitian
Hsinchu
Lize
Taoyuan
Miaoli
Xizhou
Lucao
Kanding


";
#delimit cr
}
global ctrl "Jian Nantou Taitung Puli"

}

if `km'==10{
qui{/*global inc - 10km*/
#delimit ;
global inc = "
Beitou
Bali
Wuri
Houli
Yongkang
Gangshan
Renwu
KaohCentral
KaohSouth
Tianwaitian
Hsinchu
Lize
Taoyuan
Lucao
Kanding


";
#delimit cr
}
global ctrl "Jian Nantou"

}

qui{/*global dates*/
global BeitouD = date("1999/5/27","YMD")
global BaliD = date("2001/7/17", "YMD")
global WuriD = date("2004/9/6", "YMD")
global HouliD = date("2000/8/15", "YMD")
global YongkangD = date("2008/3/1", "YMD")
global ChengxiD = date("1999/8/17", "YMD")
global GangshanD = date("2001/7/19", "YMD")
global RenwuD = date("2000/12/1", "YMD")
global KaohCentralD = date("1999/9/1", "YMD")
global KaohSouthD = date("2000/1/20", "YMD")
global TianwaitianD = date("2006/3/27", "YMD")
global HsinchuD = date("2001/2/16", "YMD")
global ChiayiD = date("1998/11/18", "YMD")
global LizeD = date("2006/4/7", "YMD")
global TaoyuanD = date("2001/10/9", "YMD")
global MiaoliD = date("2008/3/1", "YMD")
global XizhouD = date("2001/1/18", "YMD")
global LucaoD = date("2001/12/1", "YMD")
global KandingD = date("2001/12/22", "YMD")

global Beitou1ys = date("1998/5/27","YMD")
global Bali1ys = date("2000/7/17", "YMD")
global Wuri1ys = date("2003/9/6", "YMD")
global Houli1ys = date("1999/8/15", "YMD")
global Yongkang1ys = date("2007/3/1", "YMD")
global Chengxi1ys = date("1998/8/17", "YMD")
global Gangshan1ys = date("2000/7/19", "YMD")
global Renwu1ys = date("1999/12/1", "YMD")
global KaohCentral1ys = date("1998/9/1", "YMD")
global KaohSouth1ys = date("1999/1/20", "YMD")
global Tianwaitian1ys = date("2005/3/27", "YMD")
global Hsinchu1ys = date("2000/2/16", "YMD")
global Chiayi1ys = date("1997/11/18", "YMD")
global Lize1ys = date("2005/4/7", "YMD")
global Taoyuan1ys = date("2000/10/9", "YMD")
global Miaoli1ys = date("2007/3/1", "YMD")
global Xizhou1ys = date("2000/1/18", "YMD")
global Lucao1ys = date("2000/12/1", "YMD")
global Kanding1ys = date("2000/12/22", "YMD")

global Beitou1ye = date("2000/5/26", "YMD")
global Bali1ye = date("2002/7/16", "YMD")
global Wuri1ye = date("2005/9/5", "YMD")
global Houli1ye = date("2001/8/14", "YMD")
global Yongkang1ye = date("2009/2/28", "YMD")
global Chengxi1ye = date("2000/8/16", "YMD")
global Gangshan1ye = date("2002/7/18", "YMD")
global Renwu1ye = date("2001/11/30", "YMD")
global KaohCentral1ye = date("2000/8/31", "YMD")
global KaohSouth1ye = date("2001/1/19", "YMD")
global Tianwaitian1ye = date("2007/3/26", "YMD")
global Hsinchu1ye = date("2002/2/15", "YMD")
global Chiayi1ye = date("1999/11/17", "YMD")
global Lize1ye = date("2007/4/6", "YMD")
global Taoyuan1ye = date("2002/10/8", "YMD")
global Miaoli1ye = date("2009/2/28", "YMD")
global Xizhou1ye = date("2002/1/17", "YMD")
global Lucao1ye = date("2002/11/30", "YMD")
global Kanding1ye = date("2002/12/21", "YMD")
}





#delimit ;
qui global comdis =
"
comcold 
stomach
scaling
dental
";
#delimit cr


foreach inc of global inc{/*更新版 - global 年齡層*/
//2012/12/30 這一天算年齡 --> 用 global inc1ys = date("2012/12/30","YMD")

//	0-2 > 2012/12/30 滿0-2.99歲
//		  id_birthday>=2009.12.31  &  id_birthday <= 2012.12.30
local `inc'02 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-3)+1
local `inc'00 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys}))
global `inc'0002 "bday>= ``inc'02' & bday<=``inc'00' " 


//	0-5 > 2012/12/30 滿0-5.99歲
//		  id_birthday>=2006.12.31  &  id_birthday <= 2012.12.30
local `inc'05 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-6)+1
local `inc'00 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys}))
global `inc'0005 "bday>= ``inc'05' & bday<=``inc'00' " 


//	3-5 > 2012/12/30 滿3-5.99歲
//		  id_birthday>=2006.12.31  &  id_birthday <= 2009.12.30
local `inc'05 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-6)+1
local `inc'03 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-3)
global `inc'0305 "bday>= ``inc'05' & bday<=``inc'03' " 


//	60-64 > 2012/12/30 滿60-64.99歲
//		  id_birthday>=1947.12.31  &  id_birthday <= 1952.12.30
local `inc'64 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-65)+1
local `inc'60 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-60)
global `inc'6064 "bday>= ``inc'64' & bday<=``inc'60' " 


//	65-69 > 2012/12/30 滿65-69.99歲
//		  id_birthday>=1942.12.31  &  id_birthday <= 1947.12.30
local `inc'69 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-70)+1
local `inc'65 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-65)
global `inc'6569 "bday>= ``inc'69' & bday<=``inc'65' " 


//	60--- > 2012/12/30 滿60歲up
//		    id_birthday <= 1952.12.30
local `inc'60 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-60)
global `inc'6000 "bday<= ``inc'60' & bday!=. " 


//	65--- > 2012/12/30 滿65歲up
//		    id_birthday <= 1947.12.30
local `inc'65 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-65)
global `inc'6500 "bday<= ``inc'65' & bday!=. "  


//	70--- > 2012/12/30 滿70歲up
//		    id_birthday <= 1942.12.30
local `inc'70 mdy(month(${`inc'1ys}),day(${`inc'1ys}),year(${`inc'1ys})-70)
global `inc'7000 "bday<= ``inc'70' & bday!=. "  
}




global km "10 15"

qui{/*global diseases*/
//疾病
#delimit ;

global Ldead = "有無死亡";
global Ldd_in = "有無住院";
global Lemerge = "有無急診case_type";

global Lcd_dot = "門診合計點數t_dot";
global Ldd_dot = "住院醫療點數med_dot";

global Ldd_eday = "住院急診病房天數";
global Ldd_sday = "住院慢性病房天數";


/*cddd鼻子到呼吸系統到肺*/				   
global respiratory1 = "460/519";
global Lrespiratory1   = "鼻--呼吸系統--肺 460/519" ;

/*cddd鼻子到呼吸系統到肺*/				   
global respiratory2 = "460/466 472/477 478.8 478.9 480/487 490/496 500/508";
global Lrespiratory2   = "鼻--呼吸系統--肺460/466 472/477 478.8 478.9 480/487 490/496 500/508  (排除鼻中膈彎曲470.鼻瘜肉471.鼻竇粘液囊腫478.1.聲帶瘜肉478.4)" ;

/*cddd支氣管炎*/
global copd1 = "490 491 ";
global Lcopd1   = "支氣管炎490 慢性支氣管炎491" ;

global copd2 = "466 490 491";
global Lcopd2   = "急性支氣管炎466 支氣管炎490 慢性支氣管炎491" ;

global copd3 = "466 490 491 464.10 464.11 464.20 464.21 465.0 465.8 465.9 ";
global Lcopd3   = "急性支氣管炎466 支氣管炎490 慢性支氣管炎491 氣管炎464.10 464.11 464.20 464.21 465.0 465.8 465.9" ;


/*氣喘*/
global asthma1  = "493.90 493.91 493.92 494" ;
global Aasthma1   " acode == "A323" " ;
global Lasthma1  = "氣喘493.90 493.91 493.92 494" ;

global asthma2  = "464.4 493.90 493.91 493.92 494" ;
global Aasthma2   " acode == "A323" " ;
global Lasthma2  = "嘶哮464.4 氣喘493.90 493.91 493.92 494 " ;

global asthma3  = "493" ;
global Aasthma3   " acode == "A323" " ;
global Lasthma3  = "氣喘 493 " ;


/*氣喘+支氣管炎*/

global asthmacopd1 = "493.90 493.91 493.92 494 490 491";
global Lasthmacopd1   = "asthma氣喘493.90 493.91 493.92 494 + copd支氣管炎490 491" ;

global asthmacopd2 = "464.4 493.90 493.91 493.92 494 466 490 491";
global Lasthmacopd2   = "asthma嘶哮464.4 氣喘493.90 493.91 493.92 494 + copd支氣管炎466 490 491" ;

global asthmacopd3 = "493 466 490 491 464.10 464.11 464.20 464.21 465.0 465.8 465.9";
global Lasthmacopd3   = "asthma氣喘493 + copd支氣管炎466 490 491 464.10 464.11 464.20 464.21 465.0 465.8 465.9" ;


/*cddd支氣管到肺炎*/
global lung1 = "165 162 480/487";
global Llung1   = "支氣管到--肺 呼吸系統和胸內器官內其他和不明確位點的惡性腫瘤165, 支氣管及肺惡性腫瘤162, 支氣管性肺炎.肺炎480/487" ;

global lung2 = "466 490 491 464.10 464.11 464.20 464.21 465.0 465.8 465.9  485/487";
global Llung2   = "支氣管到466 490 491 464.10 464.11 464.20 464.21 465.0 465.8 465.9 肺炎485/487 " ;

global lung3 = "466 490 491 464.10 464.11 464.20 464.21 465.0 465.8 465.9  480/487";
global Llung3   = "支氣管到466 490 491 464.10 464.11 464.20 464.21 465.0 465.8 465.9 肺炎480/487" ;

global lung4 = "460/466 472/477 478.8 478.9  480/487 490/491";
global Llung4   = "鼻咽炎--支氣管--肺炎460/466 472/477 478.8 478.9  480/487 490/491" ;


/*肺炎*/
global pneumonia1  = "485/487" ;
global Lpneumonia1   = "肺炎485/487" ;					

global pneumonia2  = "480/487" ;
global Lpneumonia2   = "肺炎480/487" ;					


/*感冒
一般感冒（ICD-9 code為460或465）
流行性感冒（ICD-9 code為487）
急性咽喉炎（ICD-9 code為462/464）
急性支氣管炎（ICD-9 code為466或490）
*/

global comcold1  = "460 461 465 487 462/464 466 490" ;
global Acomcold1   "   acode=="A312" | acode=="A310" | acode=="A311" | acode=="A320" 
                    | acode=="A314" | acode=="A321" | acode=="A322"   " ;
global Lcomcold1   = "一般感冒460 461 465 流行性感冒487 急性咽喉炎462/464 急性支氣管炎466 490" ;					

global comcold2  = "460 461 465 487 " ;
global Lcomcold2   = "急性鼻咽炎(感冒)460 461 急性上呼吸道感染465 流行性感冒487" ;	
				
global comcold3  = "460 461 465" ;
global Lcomcold3   = "急性鼻咽炎(感冒)460 461 急性上呼吸道感染465" ;	



/*感冒+肺炎*/
global coldpneum1  = "460 461 465 487 462/464 466 490 480/487" ;
global Lcoldpneum1   = "一般感冒460 461 465 流行性感冒487 急性咽喉炎462/464 急性支氣管炎466 490 肺炎480/487" ;					

global coldpneum2  = "460 461 465 487 480/487 " ;
global Lcoldpneum2   = "急性鼻咽炎(感冒)460 461 急性上呼吸道感染465 流行性感冒487 肺炎480/487" ;					

global coldpneum3  = "460 461 465  480/487" ;
global Lcoldpneum3   = "急性鼻咽炎(感冒)460 461 急性上呼吸道感染465 肺炎480/487" ;					


/*肺氣腫*/
global emphysema  = "492/493" ;
global Lemphysema   = "肺氣腫 氣喘積重狀態492/493" ;					


/*塵肺症*/
global pneumoconiosis  = "500/505" ;
global Lpneumoconiosis  = "塵肺症 500/505" ;


/*眼睛疾患*/
global  eyes1   = "360/379 ";
global Aeyes1    "   acode == "A239" | acode == "A230" | acode == "A231" 
                  | acode == "A232" | acode == "A233" | acode == "A234" | acode == "A235" " ;

global Leyes1   = "眼睛疾患 360/379";


global  eyes2   = "360 364 370 372 373 375 376 379 ";
global Leyes2   = "眼睛疾患360 364 370 372 373 375 376 379 ";



/*角膜炎 結膜炎  077.1流行性角結膜炎*/
global  conjunctivitis1   = "077.1 370 372 373 375 376 379";
global Aconjunctivitis1    "  acode == "A239" | acode == "A233"  " ;
global Lconjunctivitis1   = "流行性角結膜炎077.1 角膜炎/結膜炎370 372 373 375 376 379  ";

global  conjunctivitis2   = "077.1 370 372 373";
global Aconjunctivitis2    "  acode == "A049" | acode == "A233"  " ;
global Lconjunctivitis2   = "流行性角結膜炎077.1 角膜炎/結膜炎370 372 373";


/*cddd高血壓*/
global hbp =  "402/404";
global Ahbp    "  acode == "A269" " ;
global Lhbp =  "高血壓 402/404";


/*cddd心臟*/
global heart1  = "390/429";
global Lheart1  = "心臟 390/429";

global heart2  = "410/414";
global Lheart2  = "缺血性心臟病 410/414";

global heart3  = "390/398";
global Lheart3  = "風濕性心臟病 410/414";

/*cddd心臟*/
global cardio = "390/414 418/459";
global Lcardio = "心臟 390/414 418/459";

/*cddd心肌梗塞*/
global ami    = "410/412";
global Lami    = "心肌梗塞 410/412";
	
/*心律不整*/
global arrhythmia =  "427";
global Aarrhythmia    "  acode == "A281" " ;
global Larrhythmia =  "心律不整 427";

/*cddd中風*/ 
global stroke = "433/434";
global Lstroke = "中風 433/434";


/*幼兒自閉症*/
global childautism = "299 313 314";
global Lchildautism = "幼兒自閉症299 特發於兒童及青少年期之過度焦慮症313 過動症314";

global childpsycho = "299 313/316 317/319";
global Lchildpsycho = "幼兒自閉症299 特發於兒童及青少年期之過度焦慮症313 過動症314 發展遲緩315 智能不足317/319";


/*發展遲緩*/
global retardation = "315";
global Lretardation = "發展遲緩315";


/*失意+老人痴呆+阿茲海默+帕金森氏*/
global odap ="290/294 290 331 332";
global Lodap ="譫妄 失憶 癡呆 290/294 + 老人痴呆290 331 + 阿茲海默331 + 帕金森氏332";

/*cddd失憶*/
global omental ="290/294";
global Lomental ="譫妄 失憶 癡呆 290/294";

/*cddd老人痴呆*/
global dementia = "290 331 ";
global Ldementia = "老人痴呆 290 331 ";

/*cddd阿茲海默*/ 
global alzheimer = "331";
global Lalzheimer = "阿茲海默 331";

/*cddd帕金森氏*/  
global parkinson = "332";	
global Lparkinson = "帕金森氏 332";	

			 
/*cddd精神病*/
global psycho1 = "293 295/299 300 301 306/312  313/316 317/319";
global Lpsycho1 = "精神病293 295/299 300 301 306/312  313/316 317/319";

global psycho2   = "300 311 296 295 301 306/312";
global Lpsycho2   = "焦慮症/恐慌症/強迫症/精神官能症300 憂鬱症311 躁鬱症296 精神分裂295 異常行為障礙 301 306/312";


/*情感性精神病 (躁鬱症)*/
global depresspsychosis   = "296";
global Adepresspsychosis    "  acode == "A212" " ;
global Ldepresspsychosis   = "情感性精神病(躁鬱症) 296";

/*焦慮症 恐慌症 強迫症 精神官能症*/
global anxiety   = "300";
global Lanxiety   = "焦慮症 恐慌症 強迫症 精神官能症 300";

/*憂鬱症*/
global depression   = "311";
global Adepression    "  acode == "A219" " ;
global Ldepression   = "憂鬱症 311";

/*異常行為障礙*/
global conduct   = "301 306/312 315 317/319";
global Lconduct   = "異常行為障礙 301 306/312 發展遲緩315 智能不足317/319";
;
#delimit cr


#delimit ;
global diseases =
"
respiratory1
respiratory2
copd1
copd2
copd3
asthma1
asthma2
asthma3
asthmacopd1
asthmacopd2
asthmacopd3
lung1
lung2
lung3
lung4
pneumonia1
pneumonia2
comcold1
comcold2
comcold3
coldpneum1
coldpneum2
coldpneum3
emphysema
pneumoconiosis
eyes1
eyes2
conjunctivitis1
conjunctivitis2
hbp
heart1
heart2
heart3
cardio
ami
arrhythmia
stroke
childautism
childpsycho
retardation
odap
omental
dementia
alzheimer
parkinson
psycho1
psycho2
depresspsychosis
anxiety
depression
conduct
";
#delimit cr

}




qui{
foreach icd of global diseases{
icd9to10v3 , icdin(`icd') icdoutname(`icd'_out) dtapath(icd9toicd10cmgem)
}
}

global indepYN "dead  dd_in  emerge $diseases"
global indepNUM "cd_dot dd_dot dd_eday dd_sday"
global indep "${indepNUM} ${indepYN}  "


global SEX "0 1"



qui{ /*global `inc'`km'; 20190726 update: 25km; 
無10km: Puli, Taitung, Chengxi, Miaoli, Xizhou; 
無15km: Jian; 
無20km: Taitung; 
無25km: Puli, Jian, Taitung, Lize */


#delimit ;


//吉安鄉公所
global Jian10 =
"
花蓮縣吉安鄉
花蓮縣花蓮市

";
global Jian20 =
"
花蓮縣新城鄉

";

//台東火車站
global Taitung15 =
"
臺東縣臺東市

";

global Nantou10 =
"
南投縣南投市

";
global Nantou15 =
"
南投縣名間鄉
彰化縣社頭鄉
彰化縣田中鎮

";
global Nantou20 =
"
彰化縣員林市
彰化縣二水鄉
彰化縣芬園鄉
南投縣草屯鎮
南投縣中寮鄉
南投縣集集鎮
彰化縣北斗鎮
彰化縣永靖鄉
彰化縣埔心鄉

";
global Nantou25 =
"

臺中市霧峰區
彰化縣大村鄉
彰化縣田尾鄉
雲林縣林內鄉
彰化縣花壇鄉
臺中市大里區
臺中市南區

";
global Puli15 =
"
南投縣埔里鎮

";
global Puli20 =
"
南投縣魚池鄉

";


global Beitou10 =
"
新北市蘆洲區
臺北市大同區
臺北市中山區
新北市三重區

";
global Beitou15 =
"
臺北市松山區
新北市五股區
臺北市萬華區
臺北市中正區
臺北市士林區
臺北市北投區
新北市永和區
臺北市大安區
臺北市信義區
臺北市內湖區
新北市泰山區
新北市八里區
新北市新莊區

";
global Beitou20 =
"
新北市淡水區
新北市中和區
新北市板橋區
臺北市南港區
新北市三芝區
臺北市文山區
新北市深坑區

";
global Beitou25 =
"

新北市土城區
新北市林口區
新北市金山區
桃園市龜山區
新北市石門區
新北市樹林區
新北市萬里區
基隆市七堵區
基隆市安樂區
新北市汐止區

";

global Bali10 =
"
新北市林口區
新北市八里區

";
global Bali15 =
"
新北市五股區
新北市泰山區
新北市蘆洲區

";
global Bali20 =
"
新北市新莊區
新北市三重區
新北市淡水區
桃園市龜山區
臺北市大同區
新北市板橋區
臺北市萬華區
桃園市蘆竹區

";
global Bali25 =
"
桃園市桃園區
新北市樹林區
臺北市中山區
臺北市中正區
臺北市北投區
新北市永和區
新北市中和區
新北市土城區
新北市三芝區
新北市鶯歌區
臺北市松山區
桃園市大園區
臺北市士林區
臺北市大安區

";
global Wuri10 =
"
臺中市南區
臺中市中區
臺中市烏日區
臺中市西區
臺中市南屯區

";
global Wuri15 =
"
臺中市東區
臺中市北區
臺中市大里區
彰化縣彰化市
彰化縣花壇鄉
臺中市西屯區
臺中市大肚區
彰化縣和美鎮

";
global Wuri20 =
"
彰化縣芬園鄉
彰化縣秀水鄉
彰化縣大村鄉
臺中市大雅區
臺中市霧峰區
臺中市潭子區
臺中市沙鹿區
彰化縣員林市

";
global Wuri25 =
"
臺中市龍井區
臺中市北屯區
彰化縣埔心鄉
彰化縣伸港鄉
臺中市太平區
臺中市神岡區
彰化縣線西鄉
彰化縣永靖鄉
臺中市梧棲區
彰化縣埔鹽鄉
彰化縣溪湖鎮
臺中市豐原區

";

global Houli10 =
"
臺中市神岡區
臺中市后里區
臺中市外埔區

";
global Houli15 =
"
臺中市豐原區
臺中市潭子區
臺中市大雅區
臺中市石岡區

";
global Houli20 =
"
臺中市北區
臺中市北屯區
臺中市大安區
臺中市中區
臺中市沙鹿區
臺中市西屯區
臺中市西區
臺中市東區
臺中市大甲區
苗栗縣三義鄉
臺中市清水區

";
global Houli25 =
"
苗栗縣苑裡鎮
臺中市南區
臺中市南屯區
臺中市梧棲區
臺中市東勢區
苗栗縣卓蘭鎮
臺中市大里區
臺中市大肚區

";

global Yongkang10 =
"
臺南市永康區
臺南市新市區

";
global Yongkang15 =
"
臺南市安定區
臺南市東區
臺南市北區
臺南市新化區
臺南市中西區

";
global Yongkang20 =
"
臺南市善化區
臺南市安平區
臺南市山上區
臺南市歸仁區
臺南市西港區
臺南市仁德區
臺南市南區
臺南市關廟區
臺南市左鎮區
臺南市龍崎區
高雄市湖內區

";
global Yongkang25 =
"
臺南市佳里區
臺南市麻豆區
臺南市安南區
高雄市茄萣區
高雄市阿蓮區
臺南市官田區
臺南市大內區
高雄市路竹區
臺南市下營區

";
global Chengxi10 =
"

";
global Chengxi15 =
"
臺南市安平區

";
global Chengxi20 =
"
臺南市中西區
臺南市北區
臺南市安南區
臺南市七股區
臺南市南區
臺南市東區
臺南市西港區

";
global Chengxi25 =
"
臺南市安定區
臺南市佳里區
臺南市永康區
臺南市將軍區

";
global Gangshan10 =
"
高雄市彌陀區
高雄市岡山區
高雄市永安區

";
global Gangshan15 =
"
高雄市橋頭區
高雄市路竹區
高雄市梓官區
高雄市阿蓮區
高雄市楠梓區
高雄市湖內區
高雄市茄萣區

";
global Gangshan20 =
"
高雄市大社區
高雄市燕巢區
高雄市左營區
高雄市仁武區
高雄市田寮區

";
global Gangshan25 =
"

臺南市仁德區
高雄市三民區
高雄市新興區
臺南市南區
高雄市前金區
高雄市鹽埕區
臺南市東區
高雄市鼓山區
高雄市苓雅區
臺南市歸仁區
臺南市關廟區
高雄市鳥松區
臺南市中西區
高雄市大樹區
臺南市北區
臺南市安平區

";
global Renwu10 =
"
高雄市仁武區
高雄市鳥松區
高雄市大社區

";
global Renwu15 =
"
高雄市新興區
高雄市三民區
高雄市楠梓區
高雄市大樹區
高雄市前金區
高雄市左營區
高雄市橋頭區
高雄市鹽埕區
高雄市苓雅區
高雄市鳳山區
高雄市梓官區
高雄市燕巢區
高雄市鼓山區

";
global Renwu20 =
"
屏東縣屏東市
高雄市前鎮區
屏東縣九如鄉
高雄市岡山區
高雄市旗津區
高雄市大寮區
高雄市彌陀區

";
global Renwu25 =
"
屏東縣麟洛鄉
高雄市小港區
屏東縣萬丹鄉
屏東縣竹田鄉
高雄市永安區
高雄市阿蓮區
高雄市田寮區

";

global KaohCentral10 =
"
高雄市新興區
高雄市三民區
高雄市前金區
高雄市鹽埕區
高雄市苓雅區
高雄市鳥松區
高雄市左營區
高雄市鼓山區
高雄市鳳山區

";
global KaohCentral15 =
"
高雄市楠梓區
高雄市仁武區
高雄市前鎮區
高雄市橋頭區
高雄市大社區
高雄市旗津區
高雄市梓官區

";
global KaohCentral20 =
"
高雄市大樹區
高雄市大寮區
高雄市小港區
高雄市燕巢區
高雄市彌陀區
高雄市岡山區

";
global KaohCentral25 =
"

屏東縣屏東市
屏東縣九如鄉
屏東縣萬丹鄉
屏東縣麟洛鄉
高雄市林園區
屏東縣新園鄉
高雄市永安區

";

global KaohSouth10 =
"
高雄市小港區

";
global KaohSouth15 =
"
高雄市林園區
高雄市鳳山區
高雄市苓雅區
屏東縣新園鄉
高雄市前鎮區
高雄市新興區
高雄市大寮區
高雄市前金區
高雄市鹽埕區
高雄市旗津區

";
global KaohSouth20 =
"
高雄市三民區
屏東縣萬丹鄉
高雄市鳥松區
屏東縣崁頂鄉
屏東縣東港鎮
高雄市鼓山區
屏東縣竹田鄉
屏東縣南州鄉

";
global KaohSouth25 =
"

屏東縣林邊鄉
高雄市左營區
高雄市仁武區
屏東縣麟洛鄉
屏東縣屏東市
高雄市楠梓區
屏東縣潮州鎮
高雄市大社區

";
global Tianwaitian10 =
"
基隆市信義區
基隆市仁愛區
基隆市中正區
基隆市中山區
基隆市暖暖區

";
global Tianwaitian15 =
"
基隆市安樂區

";
global Tianwaitian20 =
"
基隆市七堵區
新北市瑞芳區
新北市平溪區
新北市汐止區
新北市萬里區

";
global Tianwaitian25 =
"
臺北市內湖區
臺北市南港區
新北市金山區
新北市深坑區
新北市雙溪區
臺北市松山區

";

global Hsinchu10 =
"
新竹市北區

";
global Hsinchu15 =
"
新竹市香山區
新竹市東區

";
global Hsinchu20 =
"
新竹縣竹北市
新竹縣新豐鄉
新竹縣寶山鄉

";
global Hsinchu25 =
"
新竹縣湖口鄉
苗栗縣竹南鎮
苗栗縣頭份市
新竹縣新埔鎮

";
global Chiayi10 =
"
嘉義市西區
嘉義市東區

";
global Chiayi15 =
"
嘉義縣水上鄉

";
global Chiayi20 =
"
嘉義縣民雄鄉
嘉義縣太保市
嘉義縣中埔鄉
臺南市後壁區
臺南市白河區
嘉義縣鹿草鄉
嘉義縣新港鄉

";
global Chiayi25 =
"

嘉義縣溪口鄉
嘉義縣大林鎮
嘉義縣朴子市
嘉義縣番路鄉


";


global Lize10 =
"
宜蘭縣羅東鎮

";
global Lize15 =
"
宜蘭縣五結鄉

";
global Lize20 =
"
宜蘭縣冬山鄉
宜蘭縣壯圍鄉
宜蘭縣宜蘭市

";
global Lize25 =
"

";
global Taoyuan10 =
"
桃園市桃園區
桃園市八德區

";
global Taoyuan15 =
"
桃園市中壢區
桃園市平鎮區
新北市鶯歌區
桃園市大園區
桃園市蘆竹區

";
global Taoyuan20 =
"
桃園市龜山區
新北市樹林區

";
global Taoyuan25 =
"

新北市林口區
桃園市龍潭區
桃園市楊梅區
新北市泰山區
桃園市大溪區
桃園市觀音區
新北市新莊區
新北市土城區
新北市板橋區

";

global Miaoli10 =
"

";
global Miaoli15 =
"
苗栗縣竹南鎮
苗栗縣造橋鄉
苗栗縣頭份市

";
global Miaoli20 =
"
苗栗縣頭屋鄉
苗栗縣後龍鎮
苗栗縣苗栗市
苗栗縣三灣鄉
新竹市香山區

";
global Miaoli25 =
"
苗栗縣西湖鄉
新竹縣峨眉鄉
新竹市北區
新竹市東區
新竹縣寶山鄉

";
global Xizhou10 =
"

";
global Xizhou15 =
"
雲林縣西螺鎮
彰化縣竹塘鄉
彰化縣北斗鎮
彰化縣埤頭鄉
雲林縣二崙鄉
彰化縣田尾鄉
雲林縣莿桐鄉
彰化縣溪州鄉

";
global Xizhou20 =
"
彰化縣永靖鄉
彰化縣溪湖鎮
彰化縣田中鎮
雲林縣虎尾鎮
彰化縣埔心鄉
雲林縣崙背鄉
彰化縣二林鎮

";
global Xizhou25 =
"
彰化縣社頭鄉
雲林縣斗南鎮
雲林縣林內鄉
彰化縣埔鹽鄉
彰化縣二水鄉
雲林縣土庫鎮
彰化縣員林市
雲林縣褒忠鄉
彰化縣大城鄉

";
global Lucao10 =
"
嘉義縣朴子市
嘉義縣鹿草鄉

";
global Lucao15 =
"
嘉義縣六腳鄉
嘉義縣太保市

";
global Lucao20 =
"
臺南市後壁區
嘉義縣東石鄉
嘉義市西區
嘉義縣新港鄉

";
global Lucao25 =
"

嘉義縣義竹鄉
嘉義縣布袋鎮
雲林縣北港鎮
雲林縣水林鄉
臺南市新營區
嘉義縣水上鄉
臺南市鹽水區
嘉義市東區
嘉義縣溪口鄉

";



global Kanding10 =
"
屏東縣崁頂鄉
屏東縣南州鄉
屏東縣東港鎮
屏東縣新園鄉
屏東縣林邊鄉

";
global Kanding15 =
"
屏東縣潮州鎮
屏東縣佳冬鄉
高雄市林園區
屏東縣新埤鄉

";
global Kanding20 =
"
屏東縣萬丹鄉
屏東縣竹田鄉
屏東縣麟洛鄉
高雄市大寮區

";
global Kanding25 =
"

屏東縣萬巒鄉
屏東縣枋寮鄉
高雄市小港區
高雄市鳳山區
屏東縣屏東市
屏東縣琉球鄉


";


#delimit cr
}



***********************************************************************************************
****local PROGRESS****

//number of incs
local locnum 0
foreach inc of global inc{
	local locnum = `locnum'+1
}
global locnum = `locnum'
di "$locnum"
/*
//total counts
	local year1 = year(${`inc'1ys})-1911
	local year2 = year(${`inc'1ye})-1911
	local count = 0
	foreach yr of numlist `year1'/`year2'{
		local month1 = 1
		local month2 = 12
		if `yr' == `year1'{
			local month1 = month(${`inc'1ys})
		}/*yr=year1*/
		if `yr' == `year2'{
			local month2 = month(${`inc'1ye})
		}/*yr=year1*/
		foreach mth of numlist `month1'/`month2' {
				if `mth'<10{
					local mth = "0`mth'"
				}/*if mth<10*/
			foreach num of num 10 20{
				local count = `count' +1 
			}/*num 10 20 */
		}/*month*/
	}/*year*/
global totalcount = `count'
di "$totalcount"
*/
//agerange
global AGERANGE "0002 0305 0005 6064 6569 7000 6500 6000"

local AGENUM = 0
foreach agerange of global AGERANGE{
local AGENUM = `AGENUM'+1
}
global AGENUM = `AGENUM'

*********************************************************************************************************************************
*********************************************************************************************************************************














if `km'==15{
qui{/*global inc - 15km*/
#delimit ;
global inc = "
Lucao
Kanding


";
#delimit cr
}
global ctrl "Jian Nantou Taitung Puli"

}

if `km'==10{
qui{/*global inc - 10km*/
#delimit ;
global inc = "
Taoyuan
Lucao
Kanding


";
#delimit cr
}
global ctrl "Jian Nantou"

}

local locnum 0
foreach inc of global inc{
	local locnum = `locnum'+1
}
global locnum = `locnum'






















local loc = 0
foreach inc of global inc{
local loc = `loc'+1
local agenum = 0









/////////////////////////////////////////////////////////////////////////////////////////////////
global AGERANGE "0002 0305 0005 6064 6569 7000 6500 6000"
if `loc'==1 & `km'==15{
global AGERANGE "0305 0005 6064 6569 7000 6500 6000"
}
if `loc'==1 & `km'==10{
global AGERANGE "6569 7000 6500 6000"
}

/////////////////////////////////////////////////////////////////////////////////////////////////

















foreach agerange of global AGERANGE{

local agenum = `agenum'+1 




/////////////////////////////////////////////////////////////////////////////////////////////////
if `loc'==1 & `km'==15 & `agenum'==1{
local agenum 2
}

if `loc'==1 & `km'==10 & `agenum'==1{
local agenum 5
}
/////////////////////////////////////////////////////////////////////////////////////////////////











//----------------------------------------------------------------------

local cdyrs 1y

if `agenum' <=3{
local usefile = "`project'_06_`inc'`km'km`cdyrs'_0005_prep_20190903.dta"
}

if `agenum' >3{
local usefile = "`project'_06_`inc'`km'km`cdyrs'_6000_prep_20190903.dta"
}

//----------------------------------------------------------------------


di "==========================================================================================="
di "$S_DATE $S_TIME: `inc'(`loc'/${locnum}) `agerange'(`agenum'/${AGENUM}) start"

use "`usefile'", clear

//AGE_RANGE**--------------------------------------------------------------------------------------------

keep if ${`inc'`agerange'} 
//-------------------------------------------------------------------------------------------------------





global do "`inc' ${ctrl}"

foreach incin of global do{
global `incin'10town  = " ${`incin'10} "  
global `incin'15town = " ${`incin'10town}  ${`incin'15} "
global `incin'20town  = " ${`incin'15town} ${`incin'20} "
global `incin'10townT3  = " ${`incin'10town} ${Jian10} ${Nantou10} ${Taitung10} ${Puli10}"  
global `incin'15townT3 = " ${`incin'10townT3} ${`incin15} ${Jian15} ${Nantou15} ${Taitung15} ${Puli15}"
global `incin'20townT3  = " ${`incin'15townT3} ${`incin20} ${Jian20} ${Nantou20} ${Taitung20} ${Puli20} "
}








//DD indicator
cap drop CD
gen CD = 1
qui replace CD=0 if DD==1
drop DD






// T variables

cap drop T1 
cap drop T2
cap drop T0

qui gen T0 = 1
local cnum = 0
foreach ctrl of global ctrl{
	local cnum = `cnum'+1
	gen T`cnum' = 0

	foreach t of global `ctrl'`km'town {
		qui replace T`cnum' = 1  if township == "`t'" 
	}
	
		qui replace T0 = 0 if T`cnum'==1	
	label var T`cnum' `ctrl'
}


// 20190822: 修正township dummies，若範圍內只有一鄉鎮，不製造其dummy
cap drop dumC*
cap drop tdum*

local allno = 0
foreach incin of global do{

	local tno = 0
	foreach do of global `incin'`km'town{
		local tno = `tno'+1
		local allno = `allno'+1
		
		qui gen tdum_`incin'_`tno'_`allno' = 0
		qui replace tdum_`incin'_`tno'_`allno' = 1 if township=="`do'"
		label var tdum_`incin'_`tno' `do'
	}
	
	if `tno'==1{
	drop tdum_`incin'_`tno'_`allno'
	local allno = `allno'-1
	}
}
/*
沒有範圍內只有一個鄉鎮的情況才丟dummy
qui tab township
scalar tab_township = r(r)
local temp = tab_township
if `temp'==`allno'{
drop tdum_*_`temp'
}
*/

//不管怎麼樣都丟一個township dummy
drop tdum_*_`allno'



 *******************************************************************************SCALAR

**********************************************************************************

cap drop __00*

foreach indep of global indepYN{







cap drop `indep'_c_CD `indep'_c_DD 
cap drop `indep'_c_CD01 `indep'_c_CD02 `indep'_c_DD01 `indep'_c_DD02
cap drop `indep'_c_CD1 `indep'_c_CD2 `indep'_c_DD1 `indep'_c_DD2

sort ID










qui by ID: gen `indep'_c_CD01  = sum(`indep'YN) if infunc_mdy< ${`inc'D} & CD==1
qui by ID: gen `indep'_c_CD02  = sum(`indep'YN) if infunc_mdy>= ${`inc'D} & CD==1










qui by ID: egen `indep'_c_CD1 = max(`indep'_c_CD01) if infunc_mdy< ${`inc'D} & CD==1
qui by ID: egen `indep'_c_CD2 = max(`indep'_c_CD02) if infunc_mdy>=${`inc'D} & CD==1
qui by ID: gen `indep'_c_CD = `indep'_c_CD1
qui by ID: replace `indep'_c_CD = `indep'_c_CD2 if  infunc_mdy>= ${`inc'D}  & CD==1

qui by ID: gen `indep'_c_DD01  = sum(`indep'YN) if infunc_mdy< ${`inc'D} & CD==0
qui by ID: gen `indep'_c_DD02  = sum(`indep'YN) if infunc_mdy>= ${`inc'D} & CD==0

qui by ID: egen `indep'_c_DD1 = max(`indep'_c_DD01) if infunc_mdy< ${`inc'D} & CD==0
qui by ID: egen `indep'_c_DD2 = max(`indep'_c_DD02) if infunc_mdy>=${`inc'D} & CD==0
qui by ID: gen `indep'_c_DD = `indep'_c_DD1
qui by ID: replace `indep'_c_DD = `indep'_c_DD2 if  infunc_mdy>= ${`inc'D}  & CD==0








drop `indep'_c_CD01 `indep'_c_CD02 `indep'_c_CD1 `indep'_c_CD2 `indep'_c_DD01 `indep'_c_DD02 `indep'_c_DD1 `indep'_c_DD2
}


********************************************************************************

di "	$S_DATE $S_TIME: indepYN _c done"




cap keep ID *YN  infunc_mdy dead deadEND bday sex township tdum* *_c* T* CD/*------------------------------------------------------------------------------------------------------*/

qui compress
sort  infunc_mdy


cap gen D = 0     
qui replace D = 1 if infunc_mdy >= ${`inc'D} 



qui tempfile master D0 D1 ID
save "`master'"

keep ID infunc_mdy bday township T* tdum* sex CD
qui duplicates drop ID, force
qui save "`ID'"

use "`master'", clear
qui keep if D==0
qui duplicates drop ID, force
qui merge 1:1  ID using "`ID'", nogen
qui replace D=0 if D==.
 
qui save "`D0'"

use "`master'"
qui keep if D==1
qui duplicates drop ID, force
qui merge 1:1  ID using "`ID'", nogen 
qui replace D=1 if D==.
qui save "`D1'"
append using "`D0'"

sort ID D


cap drop DT*

local cnum = 0
foreach ctrl of global ctrl{
	local cnum = `cnum'+1
	}

foreach num of numlist 1/`cnum'{
	qui gen DT`num' = D * T`num'
	
	if `num' == `cnum'{
	*drop T`num' DT`num'
	}
}


gen DT0 = D * T0



foreach indep of global indepYN{
qui replace `indep'_c_DD=0 if `indep'_c_DD==.
qui replace `indep'_c_CD=0 if `indep'_c_CD==.

qui replace `indep'YN= 1 if `indep'_c_DD>=1 | `indep'_c_CD>=1
qui replace `indep'YN= 0 if `indep'_c_DD==0 & `indep'_c_CD==0

}

drop infunc_mdy

cap drop DDonly
cap drop DD

cap drop CD
qui gen CD=1

gen DDonly = 0
qui replace DDonly=1 if cd_dotYN==.
qui by ID: egen DD = sum(DDonly)
qui replace CD=0 if DD==2

//----------------------------------------------------------------------

local regfile = "`project'_`step'_`inc'_`now'_`km'km_`agerange'_`date'.dta"

//----------------------------------------------------------------------


qui compress
save "`regfile'", replace


********************************************************************************

di "	$S_DATE $S_TIME: file saved"









cap drop id
egen id = group(ID)
xtset id



***************************************************************************SCALAR
//計算全部人數


foreach sex of global SEX{


cap drop  idn
cap drop  id_total0
bysort ID : gen idn = _n
*qui egen id_total0 =  sum(idn) if idn==1
	qui sum idn if idn==1
	scalar id_total = r(N)

cap drop idn_s`sex'	
bysort ID : gen idn_s`sex' = _n if sex==`sex'
*qui egen id_total_s`sex'_0 = sum(idn_s`sex') if idn_s`sex'==1
	qui sum idn_s`sex' if idn_s`sex'==1
	scalar id_total_s`sex' = r(N)

	cap drop idn idn_s`sex'

di "	$S_DATE $S_TIME: idn done"



//計算各個indep

foreach indepYN of global indepYN{
bysort ID `indepYN'YN : gen `indepYN'n = _n if  `indepYN'YN==1
*qui egen `indepYN'_f0 =  sum(`indepYN'n) if `indepYN'n==1
	qui sum `indepYN'n if `indepYN'n==1
	scalar `indepYN'_f = r(N)


	bysort ID `indepYN'YN : gen `indepYN'_s`sex'n = _n if  `indepYN'YN==1 & sex==`sex'
	*qui egen `indepYN'_s`sex'_f0 =  sum(`indepYN'_s`sex'n) if `indepYN'_s`sex'n==1
		qui sum `indepYN'_s`sex'n if  `indepYN'_s`sex'n==1
		scalar `indepYN'_s`sex'_f = r(N)
	
	
	drop `indepYN'n `indepYN'_s`sex'n 
 }/*indepYN*/

 di "	$S_DATE $S_TIME: indepYN f done"

 
 
foreach indepNUM of global indepNUM{
gsort ID -`indepNUM'

cap drop `indepNUM'n `indepNUM'_s`sex'n

by ID  : gen `indepNUM'n = _n if  `indepNUM'YN>=1
*qui egen `indepNUM'_f0 =  sum(`indepNUM'n) if `indepNUM'n==1
	qui sum `indepNUM'n if `indepNUM'n==1
	scalar `indepNUM'_f = r(N)

	by ID  : gen `indepNUM'_s`sex'n = _n if  `indepNUM'YN>=1 & sex==`sex'
	*qui egen `indepNUM'_s`sex'_f0 =  sum(`indepNUM'_s`sex'n) if `indepNUM'_s`sex'n==1
		qui sum `indepNUM'_s`sex'n if `indepNUM'_s`sex'n==1
		scalar `indepNUM'_s`sex'_f = r(N)
	
	drop `indepNUM'n `indepNUM'_s`sex'n 
	
 }/*indepNUM*/

 di "	$S_DATE $S_TIME: indepNUM f done"

 


foreach indepYN of global indepYN{
*gen  `indepYN'_mean0 = 0
scalar  `indepYN'_mean = 0

	*gen  `indepYN'_s`sex'_mean0 = 0
	scalar  `indepYN'_s`sex'_mean = 0

 } /*indepYN*/

 di "	$S_DATE $S_TIME: indepYN mean done"

 

foreach indepNUM of global indepNUM{
qui sum  `indepNUM'YN if `indepNUM'YN~=0
scalar  `indepNUM'_mean = r(mean)
	qui sum  `indepNUM'YN if `indepNUM'YN~=0 & sex==`sex'
	scalar  `indepNUM'_s`sex'_mean = r(mean)
}/*indepNUM*/

di "	$S_DATE $S_TIME: indepNUM mean done"



/*
foreach indep of global indepYN{
qui sum `indep'_c_CD 
scalar `indep'_mean = r(mean)


qui sum `indep'_c_CD if sex ==`sex'
scalar `indep'_s`sex'_mean = r(mean)


qui sum `indep'_c_CD if D==0
scalar `indep'_mean_D0 = r(mean)

qui sum `indep'_c_CD if D==1
scalar `indep'_mean_D1 = r(mean)


	qui sum `indep'_c_CD if D==0 & sex ==`sex'
	scalar `indep'_mean_D0_s`sex' = r(mean)

	qui sum `indep'_c_CD if D==1 & sex ==`sex'
	scalar `indep'_mean_D1_s`sex' = r(mean)
  
  
  
  }/*indep*/  
  */
  
  
  *foreach indep of global indepNUM{
  foreach indep of global indep{
  	qui sum `indep'YN if D==0 & sex ==`sex'
	scalar `indep'_mean_D0_s`sex' = r(mean)

	qui sum `indep'YN if D==1 & sex ==`sex'
	scalar `indep'_mean_D1_s`sex' = r(mean)

  }
  
  





***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
//xtreg
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************







local glonum = 0
global indepNUM_YN ""
foreach tYN of global indepNUM{
local glonum = `glonum'+1
global temp "`tYN'YN"
global indepNUM_YN "$indepNUM_YN $temp"
}
global indepNUM_YN : list uniq global indepNUM_YN

foreach tYN of global indepYN{
local glonum = `glonum'+1
global temp "`tYN'YN"
global indepYN_YN "$indepYN_YN $temp"
}
global indepYN_YN : list uniq global indepYN_YN

global indepYN_c ""
foreach tC of global indepYN{
global temp "`tC'_c_CD"
global indepYN_c "$indepYN_c $temp"
}
global indepYN_c : list uniq global indepYN_c


global depCD "$indepNUM_YN $indepYN_c"
global depYN "$indepNUM_YN $indepYN_YN"




local yn=`glonum'

matrix zero= J(`yn',1,0)
matrix R_bD  = zero
matrix R_bDT0 = zero
matrix R_sD = zero
matrix R_sDT0 = zero

matrix R_tD  = zero
matrix R_tDT0 = zero


matrix R_R2 = zero
matrix N = zero
matrix M = zero
matrix SD = zero

matrix idN = zero
matrix indepF = zero
matrix indepM = zero

matrix indepM0 = zero
matrix indepM1 = zero




local h = 0
local k = 1 
local j = 18

foreach dep of global depYN{/*------------------------------------------------------------------------------------------------------*/
local h = `h'+1

local indep: word `h' of $indep



if "`indep'" != "dead" {
	xtreg `dep' D DT0 if deadEND==1 & sex==`sex' ,  fe
*	reg `dep' T0 T1 dumC* if deadEND==1 & sex==`sex' 
	
	
	
}
if "`indep'" == "dead" {
	xtreg `dep' D DT0 if sex==`sex' ,  fe
*	reg `dep' T0 T1  dumC* if sex==`sex' 
	
}
	
    mat R_bD[`h',1]=_b[D]
	mat R_sD[`h',1]=_se[D]
    mat R_tD[`h',1]=_b[D]/_se[D]
	
    mat R_bDT0[`h',1]=_b[DT0]
	mat R_sDT0[`h',1]=_se[DT0]
    mat R_tDT0[`h',1]=_b[DT0]/_se[DT0]
		
	mat R_R2[`h',1]=e(r2)	
    mat N[`h',1]=e(N)

qui sum `dep' if sex==`sex'
	local M  =  r(mean)	
    mat M[`h',1] =r(mean)
	mat SD[`h',1] = r(sd)

	mat idN[`h',1] = id_total_s`sex'
	
	mat indepF[`h',1] =`indep'_s`sex'_f
		if `indep'_s`sex'_f <=10{
			mat indepF[`h',1] = e(N_g)
		}	
		
	mat indepM[`h',1] =`indep'_s`sex'_mean
		if `indep'_s`sex'_mean <=3{
			mat indepM[`h',1] = 0
		}	
		
	mat indepM0[`h',1] =`indep'_mean_D0_s`sex'
		if `indep'_mean_D0_s`sex' <=3{
			mat indepM0[`h',1] = 0
		}	
	mat indepM1[`h',1] =`indep'_mean_D1_s`sex'
		if `indep'_mean_D1_s`sex' <=3{
			mat indepM1[`h',1] = 0
		}	
		

		
mat results =  (R_bD , R_tD , R_bDT0 , R_tDT0 , R_sD , R_sDT0 , R_R2 , N , M , SD, idN, indepF, indepM, indepM0, indepM1 )'  


//--------------------------------------------------
global excelfilextreg = "`project'_`km'km`cdyrs'_xtreg_depYN3_`date'"/*---------------------------------------------------------------------------------*/
//--------------------------------------------------

putexcel set "$excelfilextreg",  sheet("`inc'`km'km`cdyrs'`agerange's`sex'") modify
*putexcel set "$excelfile",  sheet("`inc'`km'km`cdyrs'`agerange'") modify




local k = `k'+1 
if `k'<=26{
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel `C'1 = ("`indep'")
}

if `k'>=27 & `k'<=52{
local k = `k' - 26
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel A`C'1 = ("`indep'")
local k = `k' + 26
}

if `k'>=53 {
local k = `k' - 52
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel B`C'1 = ("`indep'")
local k = `k' + 52
}

local j = `j'+1
qui putexcel A`j' = ("`indep'  ${L`indep'}")

di "$S_DATE $S_TIME depYN `inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_`indep'(`h'/`glonum')_s`sex'_completed"


putexcel B2 = matrix(results)







} /*dep*/

qui{/*put row name*/
putexcel A1 = ("`inc'`agerange'`sex'")
*putexcel A1 = ("`inc'`agerange'")

qui putexcel A2 = ("R_bD  ")
qui putexcel A3 = ("R_tD  ")	
qui putexcel A4 = ("R_bDT0  ")
qui putexcel A5 = ("R_tDT0  ")
qui putexcel A6 = ("R_sD ")
qui putexcel A7 = ("R_sDT0  ")
qui putexcel A8 = ("R2 ")
qui putexcel A9 = ("N ")
qui putexcel A10 = ("M ")
qui putexcel A11 = ("SD ")
qui putexcel A12 = ("idN ")
qui putexcel A13 = ("indepF ")
qui putexcel A14 = ("indepM ")
qui putexcel A15 = ("indepM0 ")
qui putexcel A16 = ("indepM1 ")

}/*qui row name*/

di "--------------------------------------------------------------------------------------"
di "$S_DATE $S_TIME: `inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_s`sex'_xtreg_depYN completed"












***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
//reg
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************


local yn=`glonum'

matrix zero= J(`yn',1,0)
matrix R_bT0  = zero
matrix R_bT1 = zero
matrix R_sT0 = zero
matrix R_sT1 = zero
matrix R_tT0 = zero
matrix R_tT1 = zero


matrix R_R2 = zero
matrix N = zero
matrix M = zero
matrix SD = zero

matrix idN = zero
matrix indepF = zero
matrix indepM0 = zero
matrix indepM1 = zero

matrix indepM = zero



local h = 0
local k = 1 
local j = 18

foreach dep of global depYN{/*=============================================================================*/
local h = `h'+1

local indep: word `h' of $indep

local dumnum = `cnum'-1

if "`indep'" != "dead" {
	reg `dep' T0-T`dumnum' tdum* if deadEND==1 & sex==`sex' 
	
	
	
}
if "`indep'" == "dead" {
	reg `dep' T0-T`dumnum' tdum* if sex==`sex' 
	
}
	
    mat R_bT0[`h',1]=_b[T0]
	mat R_sT0[`h',1]=_se[T0]
    mat R_tT0[`h',1]=_b[T0]/_se[T0]
	
    mat R_bT1[`h',1]=_b[T1]
	mat R_sT1[`h',1]=_se[T1]
    mat R_tT1[`h',1]=_b[T1]/_se[T1]
		
	mat R_R2[`h',1]=e(r2)	
    mat N[`h',1]=e(N)

qui sum `dep' if sex==`sex'
	local M  =  r(mean)	
    mat M[`h',1] =r(mean)
	mat SD[`h',1] = r(sd)

	mat idN[`h',1] = id_total_s`sex'
	
	mat indepF[`h',1] =`indep'_s`sex'_f
		if `indep'_s`sex'_f <=10{
			mat indepF[`h',1] = e(N_g)
		}	
		
	mat indepM0[`h',1] =`indep'_mean_D0_s`sex'
		if `indep'_mean_D0_s`sex' <=3{
			mat indepM0[`h',1] = 0
		}	
	mat indepM1[`h',1] =`indep'_mean_D1_s`sex'
		if `indep'_mean_D1_s`sex' <=3{
			mat indepM1[`h',1] = 0
		}	
	mat indepM[`h',1] = `indep'_s`sex'_mean	
		if `indep'_s`sex'_mean <=3{
			mat indepM0[`h',1] = 0
		}	

		
mat results =  (R_bT0 , R_tT0 , R_bT1 , R_tT1 , R_sT0 , R_sT1 , R_R2 , N , M , SD, idN, indepF, indepM, indepM0, indepM1 )'  


//--------------------------------------------------
global excelfilereg = "`project'_`km'km`cdyrs'_reg_depYN3_`date'"/*----------------------------------------------------------------------------*/
//--------------------------------------------------


putexcel set "$excelfilereg",  sheet("`inc'`km'km`cdyrs'`agerange's`sex'") modify
*putexcel set "$excelfile",  sheet("`inc'`km'km`cdyrs'`agerange'") modify




local k = `k'+1 
if `k'<=26{
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel `C'1 = ("`indep'")
}

if `k'>=27 & `k'<=52{
local k = `k' - 26
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel A`C'1 = ("`indep'")
local k = `k' + 26
}

if `k'>=53 {
local k = `k' - 52
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel B`C'1 = ("`indep'")
local k = `k' + 52
}

local j = `j'+1
qui putexcel A`j' = ("`indep'  ${L`indep'}")

di "	$S_DATE $S_TIME: depYN_`inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_`indep'(`h'/`glonum')_s`sex'_completed"
*di "`inc'_`agerange'_`indep'_completed"


putexcel B2 = matrix(results)

} /*dep*/

qui{/*put row name*/
putexcel A1 = ("`inc'`agerange'`sex'")
*putexcel A1 = ("`inc'`agerange'")

qui putexcel A2 = ("R_bT0  ")
qui putexcel A3 = ("R_tT0 ")	
qui putexcel A4 = ("R_bT1  ")
qui putexcel A5 = ("R_tT1  ")
qui putexcel A6 = ("R_sT0 ")
qui putexcel A7 = ("R_sT1  ")
qui putexcel A8 = ("R2 ")
qui putexcel A9 = ("N ")
qui putexcel A10 = ("M ")
qui putexcel A11 = ("SD ")
qui putexcel A12 = ("idN ")
qui putexcel A13 = ("indepF ")
qui putexcel A14 = ("indepM ")
qui putexcel A15 = ("indepM0 ")
qui putexcel A16 = ("indepM1 ")

}/*qui row name*/

di "--------------------------------------------------------------------------------------"
di "$S_DATE $S_TIME: `inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_s`sex'_reg_depYN_completed"




}/*sex*/


//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////
//**************//////////***************///////////************////////////**************///////////////////**************///////////


drop if CD==0

***************************************************************************SCALAR
//計算全部人數


foreach sex of global SEX{


cap drop  idn
cap drop  id_total0
bysort ID : gen idn = _n
*qui egen id_total0 =  sum(idn) if idn==1
	qui sum idn if idn==1
	scalar id_total = r(N)

cap drop idn_s`sex'	
bysort ID : gen idn_s`sex' = _n if sex==`sex'
*qui egen id_total_s`sex'_0 = sum(idn_s`sex') if idn_s`sex'==1
	qui sum idn_s`sex' if idn_s`sex'==1
	scalar id_total_s`sex' = r(N)

	cap drop idn idn_s`sex'

di "	$S_DATE $S_TIME: idn done"



//計算各個indep

foreach indepYN of global indepYN{
bysort ID `indepYN'YN : gen `indepYN'n = _n if  `indepYN'YN==1
*qui egen `indepYN'_f0 =  sum(`indepYN'n) if `indepYN'n==1
	qui sum `indepYN'n if `indepYN'n==1
	scalar `indepYN'_f = r(N)


	bysort ID `indepYN'YN : gen `indepYN'_s`sex'n = _n if  `indepYN'YN==1 & sex==`sex'
	*qui egen `indepYN'_s`sex'_f0 =  sum(`indepYN'_s`sex'n) if `indepYN'_s`sex'n==1
		qui sum `indepYN'_s`sex'n if  `indepYN'_s`sex'n==1
		scalar `indepYN'_s`sex'_f = r(N)
	
	
	drop `indepYN'n `indepYN'_s`sex'n 
 }/*indepYN*/

 di "	$S_DATE $S_TIME: indepYN f done"

 
 
foreach indepNUM of global indepNUM{
gsort ID -`indepNUM'

cap drop `indepNUM'n `indepNUM'_s`sex'n

by ID  : gen `indepNUM'n = _n if  `indepNUM'YN>=1
*qui egen `indepNUM'_f0 =  sum(`indepNUM'n) if `indepNUM'n==1
	qui sum `indepNUM'n if `indepNUM'n==1
	scalar `indepNUM'_f = r(N)

	by ID  : gen `indepNUM'_s`sex'n = _n if  `indepNUM'YN>=1 & sex==`sex'
	*qui egen `indepNUM'_s`sex'_f0 =  sum(`indepNUM'_s`sex'n) if `indepNUM'_s`sex'n==1
		qui sum `indepNUM'_s`sex'n if `indepNUM'_s`sex'n==1
		scalar `indepNUM'_s`sex'_f = r(N)
	
	drop `indepNUM'n `indepNUM'_s`sex'n 
	
 }/*indepNUM*/

 di "	$S_DATE $S_TIME: indepNUM f done"

 


foreach indepYN of global indepYN{
*gen  `indepYN'_mean0 = 0
scalar  `indepYN'_mean = 0

	*gen  `indepYN'_s`sex'_mean0 = 0
	scalar  `indepYN'_s`sex'_mean = 0

 } /*indepYN*/

 di "	$S_DATE $S_TIME: indepYN mean done"

 

foreach indepNUM of global indepNUM{
qui sum  `indepNUM'YN if `indepNUM'YN~=0
scalar  `indepNUM'_mean = r(mean)
	qui sum  `indepNUM'YN if `indepNUM'YN~=0 & sex==`sex'
	scalar  `indepNUM'_s`sex'_mean = r(mean)
}/*indepNUM*/

di "	$S_DATE $S_TIME: indepNUM mean done"




foreach indep of global indepYN{
qui sum `indep'_c_CD 
scalar `indep'_mean = r(mean)


qui sum `indep'_c_CD if sex ==`sex'
scalar `indep'_s`sex'_mean = r(mean)


qui sum `indep'_c_CD if D==0
scalar `indep'_mean_D0 = r(mean)

qui sum `indep'_c_CD if D==1
scalar `indep'_mean_D1 = r(mean)


	qui sum `indep'_c_CD if D==0 & sex ==`sex'
	scalar `indep'_mean_D0_s`sex' = r(mean)

	qui sum `indep'_c_CD if D==1 & sex ==`sex'
	scalar `indep'_mean_D1_s`sex' = r(mean)
  
  
  
  }/*indep*/  
  
  
  *foreach indep of global indep{
  foreach indep of global indepNUM{
  	qui sum `indep'YN if D==0 & sex ==`sex'
	scalar `indep'_mean_D0_s`sex' = r(mean)

	qui sum `indep'YN if D==1 & sex ==`sex'
	scalar `indep'_mean_D1_s`sex' = r(mean)

  }
  
  





***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
//xtreg
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************







local glonum = 0
global indepNUM_YN ""
foreach tYN of global indepNUM{
local glonum = `glonum'+1
global temp "`tYN'YN"
global indepNUM_YN "$indepNUM_YN $temp"
}
global indepNUM_YN : list uniq global indepNUM_YN

foreach tYN of global indepYN{
local glonum = `glonum'+1
global temp "`tYN'YN"
global indepYN_YN "$indepYN_YN $temp"
}
global indepYN_YN : list uniq global indepYN_YN


global indepYN_c ""
foreach tC of global indepYN{
global temp "`tC'_c_CD"
global indepYN_c "$indepYN_c $temp"
}
global indepYN_c : list uniq global indepYN_c


global depCD "$indepNUM_YN $indepYN_c"
global depYN "$indepNUM_YN $indepYN_YN"




local yn=`glonum'

matrix zero= J(`yn',1,0)
matrix R_bD  = zero
matrix R_bDT0 = zero
matrix R_sD = zero
matrix R_sDT0 = zero

matrix R_tD  = zero
matrix R_tDT0 = zero


matrix R_R2 = zero
matrix N = zero
matrix M = zero
matrix SD = zero

matrix idN = zero
matrix indepF = zero
matrix indepM = zero

matrix indepM0 = zero
matrix indepM1 = zero




local h = 0
local k = 1 
local j = 18

foreach dep of global depCD{/*------------------------------------------------------------------------------------------------------*/
local h = `h'+1

local indep: word `h' of $indep



if "`indep'" != "dead" {
	xtreg `dep' D DT0 if deadEND==1 & sex==`sex' ,  fe
*	reg `dep' T0 T1 dumC* if deadEND==1 & sex==`sex' 
	
	
	
}
if "`indep'" == "dead" {
	xtreg `dep' D DT0 if sex==`sex' ,  fe
*	reg `dep' T0 T1  dumC* if sex==`sex' 
	
}
	
    mat R_bD[`h',1]=_b[D]
	mat R_sD[`h',1]=_se[D]
    mat R_tD[`h',1]=_b[D]/_se[D]
	
    mat R_bDT0[`h',1]=_b[DT0]
	mat R_sDT0[`h',1]=_se[DT0]
    mat R_tDT0[`h',1]=_b[DT0]/_se[DT0]
		
	mat R_R2[`h',1]=e(r2)	
    mat N[`h',1]=e(N)

qui sum `dep' if sex==`sex'
	local M  =  r(mean)	
    mat M[`h',1] =r(mean)
	mat SD[`h',1] = r(sd)

	mat idN[`h',1] = id_total_s`sex'
	
	mat indepF[`h',1] =`indep'_s`sex'_f
		if `indep'_s`sex'_f <=10{
			mat indepF[`h',1] = e(N_g)
		}	
		
	mat indepM[`h',1] =`indep'_s`sex'_mean
		if `indep'_s`sex'_mean <=3{
			mat indepM[`h',1] = 0
		}	
		
	mat indepM0[`h',1] =`indep'_mean_D0_s`sex'
		if `indep'_mean_D0_s`sex' <=3{
			mat indepM0[`h',1] = 0
		}	
	mat indepM1[`h',1] =`indep'_mean_D1_s`sex'
		if `indep'_mean_D1_s`sex' <=3{
			mat indepM1[`h',1] = 0
		}	
		

		
mat results =  (R_bD , R_tD , R_bDT0 , R_tDT0 , R_sD , R_sDT0 , R_R2 , N , M , SD, idN, indepF, indepM, indepM0, indepM1 )'  


//--------------------------------------------------
global excelfilextreg = "`project'_`km'km`cdyrs'_xtreg_depCD3_`date'"/*---------------------------------------------------------------------------------*/
//--------------------------------------------------

putexcel set "$excelfilextreg",  sheet("`inc'`km'km`cdyrs'`agerange's`sex'") modify
*putexcel set "$excelfile",  sheet("`inc'`km'km`cdyrs'`agerange'") modify




local k = `k'+1 
if `k'<=26{
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel `C'1 = ("`indep'")
}

if `k'>=27 & `k'<=52{
local k = `k' - 26
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel A`C'1 = ("`indep'")
local k = `k' + 26
}

if `k'>=53 {
local k = `k' - 52
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel B`C'1 = ("`indep'")
local k = `k' + 52
}

local j = `j'+1
qui putexcel A`j' = ("`indep'  ${L`indep'}")

di "$S_DATE $S_TIME depCD `inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_`indep'(`h'/`glonum')_s`sex'_completed"


putexcel B2 = matrix(results)







} /*dep*/

qui{/*put row name*/
putexcel A1 = ("`inc'`agerange'`sex'")
*putexcel A1 = ("`inc'`agerange'")

qui putexcel A2 = ("R_bD  ")
qui putexcel A3 = ("R_tD  ")	
qui putexcel A4 = ("R_bDT0  ")
qui putexcel A5 = ("R_tDT0  ")
qui putexcel A6 = ("R_sD ")
qui putexcel A7 = ("R_sDT0  ")
qui putexcel A8 = ("R2 ")
qui putexcel A9 = ("N ")
qui putexcel A10 = ("M ")
qui putexcel A11 = ("SD ")
qui putexcel A12 = ("idN ")
qui putexcel A13 = ("indepF ")
qui putexcel A14 = ("indepM ")
qui putexcel A15 = ("indepM0 ")
qui putexcel A16 = ("indepM1 ")

}/*qui row name*/

di "--------------------------------------------------------------------------------------"
di "$S_DATE $S_TIME: `inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_s`sex'_xtreg_dep_CD_completed"












***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
//reg
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************


local yn=`glonum'

matrix zero= J(`yn',1,0)
matrix R_bT0  = zero
matrix R_bT1 = zero
matrix R_sT0 = zero
matrix R_sT1 = zero
matrix R_tT0 = zero
matrix R_tT1 = zero


matrix R_R2 = zero
matrix N = zero
matrix M = zero
matrix SD = zero

matrix idN = zero
matrix indepF = zero
matrix indepM0 = zero
matrix indepM1 = zero

matrix indepM = zero



local h = 0
local k = 1 
local j = 18

foreach dep of global depCD{/*=============================================================================*/
local h = `h'+1

local indep: word `h' of $indep

local dumnum = `cnum'-1

if "`indep'" != "dead" {
	reg `dep' T0-T`dumnum' tdum* if deadEND==1 & sex==`sex' 
	
	
	
}
if "`indep'" == "dead" {
	reg `dep' T0-T`dumnum' tdum* if sex==`sex' 
	
}
	
    mat R_bT0[`h',1]=_b[T0]
	mat R_sT0[`h',1]=_se[T0]
    mat R_tT0[`h',1]=_b[T0]/_se[T0]
	
    mat R_bT1[`h',1]=_b[T1]
	mat R_sT1[`h',1]=_se[T1]
    mat R_tT1[`h',1]=_b[T1]/_se[T1]
		
	mat R_R2[`h',1]=e(r2)	
    mat N[`h',1]=e(N)

qui sum `dep' if sex==`sex'
	local M  =  r(mean)	
    mat M[`h',1] =r(mean)
	mat SD[`h',1] = r(sd)

	mat idN[`h',1] = id_total_s`sex'
	
	mat indepF[`h',1] =`indep'_s`sex'_f
		if `indep'_s`sex'_f <=10{
			mat indepF[`h',1] = e(N_g)
		}	
		
	mat indepM0[`h',1] =`indep'_mean_D0_s`sex'
		if `indep'_mean_D0_s`sex' <=3{
			mat indepM0[`h',1] = 0
		}	
	mat indepM1[`h',1] =`indep'_mean_D1_s`sex'
		if `indep'_mean_D1_s`sex' <=3{
			mat indepM1[`h',1] = 0
		}	
	mat indepM[`h',1] = `indep'_s`sex'_mean	
		if `indep'_s`sex'_mean <=3{
			mat indepM0[`h',1] = 0
		}	

		
mat results =  (R_bT0 , R_tT0 , R_bT1 , R_tT1 , R_sT0 , R_sT1 , R_R2 , N , M , SD, idN, indepF, indepM, indepM0, indepM1 )'  


//--------------------------------------------------
global excelfilereg = "`project'_`km'km`cdyrs'_reg_depCD3_`date'"/*----------------------------------------------------------------------------*/
//--------------------------------------------------


putexcel set "$excelfilereg",  sheet("`inc'`km'km`cdyrs'`agerange's`sex'") modify
*putexcel set "$excelfile",  sheet("`inc'`km'km`cdyrs'`agerange'") modify




local k = `k'+1 
if `k'<=26{
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel `C'1 = ("`indep'")
}

if `k'>=27 & `k'<=52{
local k = `k' - 26
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel A`C'1 = ("`indep'")
local k = `k' + 26
}

if `k'>=53 {
local k = `k' - 52
local c=1
local C = word("`c(ALPHA)'",`k')
qui putexcel B`C'1 = ("`indep'")
local k = `k' + 52
}

local j = `j'+1
qui putexcel A`j' = ("`indep'  ${L`indep'}")

di "	$S_DATE $S_TIME: depCD `inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_`indep'(`h'/`glonum')_s`sex'_completed"
*di "`inc'_`agerange'_`indep'_completed"


putexcel B2 = matrix(results)

} /*dep*/

qui{/*put row name*/
putexcel A1 = ("`inc'`agerange'`sex'")
*putexcel A1 = ("`inc'`agerange'")

qui putexcel A2 = ("R_bT0  ")
qui putexcel A3 = ("R_tT0 ")	
qui putexcel A4 = ("R_bT1  ")
qui putexcel A5 = ("R_tT1  ")
qui putexcel A6 = ("R_sT0 ")
qui putexcel A7 = ("R_sT1  ")
qui putexcel A8 = ("R2 ")
qui putexcel A9 = ("N ")
qui putexcel A10 = ("M ")
qui putexcel A11 = ("SD ")
qui putexcel A12 = ("idN ")
qui putexcel A13 = ("indepF ")
qui putexcel A14 = ("indepM ")
qui putexcel A15 = ("indepM0 ")
qui putexcel A16 = ("indepM1 ")

}/*qui row name*/

di "--------------------------------------------------------------------------------------"
di "$S_DATE $S_TIME: `inc'(`loc'/${locnum})_`agerange'(`agenum'/${AGENUM})_s`sex'_regCD_completed"




}/*sex*/











}/*agerange*/
}/*inc*/



*************************************************************************************
log c
