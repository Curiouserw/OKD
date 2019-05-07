from selenium import webdriver
from time import sleep
from selenium.webdriver.remote.remote_connection import RemoteConnection

remoteconnection = RemoteConnection('http://zalenium-zalenium.apps.allinone.curiouser.com/wd/hub', keep_alive=False,resolve_ip=False)
driver = webdriver.Remote(command_executor=remoteconnection,desired_capabilities={'browserName': 'chrome'})

driver.get('https://www.baidu.com')
driver.find_element_by_id("kw").send_keys("docker selenium")
driver.find_element_by_id("su").click()
sleep(1)
driver.quit()
