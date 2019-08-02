return function(msg)
    local status = io.open('/proc/self/status','r'):read('*a')
    local BOT_USE = re.match(status,'VmRSS:\\s*(.*) kB'):gsub('%s*','')
    status = [[
        [ Статистика ]
        Процессор:
        &#8195;UPTIME&#8195;Температура: TEMP
        ОЗУ:
        &#8195;Всего: RAM_FULL МБ
        &#8195;Использовано: RAM_USE МБ
        &#8195;Использовано ботом: BOT_USE кБ
        Бот:
        &#8195;Время работы: WORK_TIME
    ]]
    status = status:gsub('BOT_USE',BOT_USE):gsub('UPTIME',io.popen('uptime'):read('*a'))
    local WORK_TIME = math.floor((os.time()-msg.bot_stat.work_start)/(60*60*24))..' дней | '..math.floor((os.time()-msg.bot_stat.work_start)/(60*60))..' часов | '
    WORK_TIME = WORK_TIME..math.floor((os.time()-msg.bot_stat.work_start)/(60))..' минут | '..math.floor(os.time()-msg.bot_stat.work_start)..' секунд'

    RAM = {}
    for i in io.popen('free -m'):read('*a'):gmatch('%d+') do RAM[#RAM+1]=i if #RAM==2 then break end end
    status = status:gsub('RAM_FULL',RAM[1]):gsub('RAM_USE',RAM[2])

    status = status:gsub('WORK_TIME',WORK_TIME):gsub('TEMP',io.open('/sys/class/thermal/thermal_zone0/temp','r'):read('*a')/1000)
    libkb.apisay(status,msg.toho)
end