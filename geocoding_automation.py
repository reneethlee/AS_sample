import os
from selenium import webdriver
# from selenium.webdriver.common.keys import Keys
# from selenium.webdriver import ActionChains
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
# from selenium.common.exceptions import WebDriverException as WE
from selenium.common.exceptions import TimeoutException as TE
from selenium.webdriver.common.by import By  
from selenium.common.exceptions import NoSuchElementException
import time
import datetime
from datetime import date
import logging
from os import listdir
from os.path import isfile, join
import win32com.client
import sys
from random import randint

options = webdriver.ChromeOptions()
options.add_argument("--start-maximized")
options.add_argument("--disable-gpu")
options.add_argument("--disable-browser-side-navigation")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--disable-infobars")
options.add_argument("--no-sandbox")
options.add_argument("--incognito") 
options.add_argument("enable-automation")
options.add_experimental_option('excludeSwitches', ['enable-logging'])

cd = "E:\\User_Data\\Documents\\Desktop_20200421\\20200421_soil_liquefaction\\"
os.chdir("E:\\User_Data\\Documents\\Desktop_20200421\\20200421_soil_liquefaction\\050TGOS_input_upload_download\\")

FORMAT = '%(asctime)s %(levelname)s: %(message)s'
DATE_FORMAT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(level=logging.INFO, filename=cd+"052log_save\\TGOS_auto_upload.log",
                    filemode='a', format=FORMAT, datefmt=DATE_FORMAT)

kill_hour = 8
kill_min = 30
kill_sec = 0

path = ""
files = [f for f in listdir(cd) if isfile(join(cd, f))]

acc_list = ["xxxx@gate.sinica.edu.tw",
            "xxxx@econ.sinica.edu.tw"]

num = -1
for turn in range(len(acc_list)):
    # random = randint(5, 25)
    # random = random * 60
    # time.sleep(random)

    acc = acc_list[turn]
    logging.info(acc)
    try:
        if acc == "xxxxx@gate.sinica.edu.tw":
            password = "xxxx"
            api_key = "xxxx"
        else:
            password = "1234"
            api_key = "134"
        driver = webdriver.Chrome(options=options)
        driver.get("https://www.tgos.tw/TGOS/Web/Address/TGOS_Address.aspx")
        wait = WebDriverWait(driver, 60, poll_frequency=0.0001)  
        quick_wait = WebDriverWait(driver, 5, poll_frequency=0.0001) 

        while True:
            try:
                wait.until(EC.element_to_be_clickable((By.XPATH, "//a[contains(text(),'登入')]"))) \
                    .click() 
                box_account = "//input[@id='USM_AccountLogonBox_UserId_txt']"
                box_password = "//input[@id='USM_AccountLogonBox_UserPassword_txt']"
                wait.until(EC.element_to_be_clickable((By.XPATH, box_password))) \
                    .click()  
                driver.find_element_by_xpath(box_password).send_keys(password)
                wait.until(EC.element_to_be_clickable((By.XPATH, box_account))) \
                    .click()  
                time.sleep(1)
                driver.find_element_by_xpath(box_account).send_keys(acc)
                driver.find_element_by_xpath("//input[@id='USM_AccountLogonBox_Logon']").click()
                driver.refresh()
                driver.find_element_by_xpath("//a[@title='登出']")
                break
            except NoSuchElementException:
                continue

        wait.until(EC.element_to_be_clickable((By.XPATH, "//div[contains(text(),'批次門牌地址比對服務')]"))) \
            .click() 
        wait.until(EC.frame_to_be_available_and_switch_to_it('TGOS_AddressBox_Content_BatchQuery_iFrame'))

        api_path = "//*[@id='ADDR_BOX_APIKEY']"
        wait.until(EC.presence_of_element_located((By.XPATH, api_path))) \
            .click()  # APIKEY
        driver.find_element_by_xpath(api_path).send_keys(api_key)
        ppath = "E:\\User_Data\\Documents\\Desktop_20200421\\20200421_soil_liquefaction\\050TGOS_input_upload_download\\"
        num += 1
        file = os.listdir(ppath)[num]
        file1 = ppath + file
        wait.until(EC.element_to_be_clickable((By.XPATH, "//input[@id='ADDR_BOX_Filebt']"))).click()
        time.sleep(1)
        shell = win32com.client.Dispatch("WScript.Shell")
        shell.Sendkeys(file1)
        # print(num, file1)
        time.sleep(1)
        shell.Sendkeys("{Enter}")
        print(acc, "enter file")
        time.sleep(2)
        #
        # except (IOError, OSError):
        #     num += 1
        #     file = os.listdir(ppath)[num]
        #     print(num, file1)
        #     file1 = ppath + file
        #     shell.Sendkeys("^(a)^({BACKSPACE})")
        #     print("BACK")
        #     time.sleep(3)
        # driver.find_element_by_xpath("//input[@id='ADDR_BOX_IS_SUPPORT_HISTORY']").click()
        wait.until(EC.element_to_be_clickable((By.XPATH, "//input[@id='ADDR_BOX_IS_SUPPORT_HISTORY']"))).click()
        driver.find_element_by_xpath("//input[@id='ADDR_BOX_EXECUTE']").click()
        print(acc, "uploaded", file)
        message = "      uploaded file " + file
        logging.info(message)
        try:
            quick_wait.until(EC.presence_of_element_located((By.XPATH, "//div[contains(text(),'資料檢核成功')]")))
            print(acc, "success")
            logging.info("      successful")
        except TE:
            print(acc, "something went wrong")
            logging.info("      cannot detect success message")
            continue
        ppath2 = \
            "E:\\User_Data\\Documents\\Desktop_20200421\\" \
            "20200421_soil_liquefaction\\050TGOS_input_upload_download\\uploaded\\"
        file2 = ppath2 + file
        time.sleep(2)
        try:
            os.rename(file1, file2)
            print(acc, "moved", file)
            logging.info("      moved file")
            num = -1
        except (OSError, IOError):
            print(acc, "error in moving file", file)
            logging.info("      error in moving file")
        driver.switch_to.default_content()
        time.sleep(20)
        driver.find_element_by_xpath("//a[@title='登出']").click()
        driver.quit()
        print(acc, "done")
        logging.info("      logged-off and browser closed")

    except Exception as e:
        print(e)
        logging.warning(e)
        driver.quit()

kill_time = \
    datetime.datetime(date.today().year, date.today().month, date.today().day, kill_hour, kill_min, kill_sec)

while datetime.datetime.now() <= kill_time:
    time.sleep(60)

sys.exit()
