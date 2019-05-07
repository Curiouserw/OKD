# -*- coding: utf-8 -*-
from selenium import webdriver
from selenium.webdriver.remote.remote_connection import RemoteConnection
# 创建远程连接selenium grid
remoteconnection = RemoteConnection('http://zalenium-zalenium.apps.allinone.curiouser.com/wd/hub', keep_alive=False,
                                    resolve_ip=False)

driver = webdriver.Remote(command_executor=remoteconnection,
                          desired_capabilities={
                              'browserName': "chrome",
                              'video': 'True',
                              'platform': 'LINUX',
                              'platformName': 'LINUX'
                          })
try:
    driver.implicitly_wait(30)
    driver.maximize_window()
    driver.get("http://www.baidu.com")
    assert u'百度一下，你就知道' in driver.title
    kw_input = driver.find_element_by_id('kw')
    su_button = driver.find_element_by_id('su')
    kw_input.clear()
   # 输入关键字Openshift
    kw_input.send_keys('Openshift')
    su_button.click()

finally:
    driver.quit()
