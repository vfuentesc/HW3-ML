train_set = train[, c("year", "month", "day", "hour", "temp", "atemp", "humidity", "windspeed")]
test_set = test[, c("year", "month", "day", "hour", "temp", "atemp", "humidity", "windspeed")]
total_set = rbind(train_set, test_set)

total_set[, date := ymd_h(paste(year, month, day, hour, sep = "-"))]
total_set[, date_num := as.numeric(date)]

total_set = total_set[order(date_num)]

smooth_temp = loess(temp ~ date_num, data = total_set, span = 0.1)
smooth_atemp = loess(atemp ~ date_num, data = total_set, span = 0.1)
smooth_humidity = loess(humidity ~ date_num, data = total_set, span = 0.1)
smooth_windspeed = loess(windspeed ~ date_num, data = total_set, span = 0.1)

df_temp = data.table(smooth_temp$x, s_temp = smooth_temp$fitted)
df_atemp = data.table(smooth_atemp$x, s_atemp = smooth_atemp$fitted)
df_humidity = data.table(smooth_humidity$x, s_humidity = smooth_humidity$fitted)
df_windspeed = data.table(smooth_windspeed$x, s_windspeed = smooth_windspeed$fitted)

total_set = merge(total_set, df_temp, by = c("date_num"))
total_set = merge(total_set, df_atemp, by = c("date_num"))
total_set = merge(total_set, df_humidity, by = c("date_num"))
total_set = merge(total_set, df_windspeed, by = c("date_num"))

total_set = total_set[, c("year", "month", "day", "hour", "s_temp", "s_atemp", "s_humidity", "s_windspeed")]
