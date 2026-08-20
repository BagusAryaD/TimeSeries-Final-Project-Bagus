library(forecast)
library(tseries)
library(ggplot2) 
library(dplyr) 

# Membaca data
data <- read.csv("Data Historis BBCA.csv", colClasses = "character")
data$Terakhir <- as.numeric(gsub(",", ".", gsub("\\.", "", data$Terakhir)))

# Mengubah data menjadi tanggal
data$Tanggal <- as.Date(data$Tanggal, format = "%d/%m/%Y")
data <- data[order(data$Tanggal), ]
head(data)
tail(data)

# Buat objek time series
ts_bbca <- ts(data$Terakhir, start = c(as.numeric(format(min(data$Tanggal), "%Y")), as.numeric(format(min(data$Tanggal), "%j"))), frequency = 1)
summary(ts_bbca)

# Plot deret waktu
plot_df <- data.frame(Tanggal = data$Tanggal, Harga = data$Terakhir)
ggplot(plot_df, aes(x = Tanggal, y = Harga)) +
  geom_line(color = "#2C3E50", size = 1) +
  ggtitle("Pergerakan Harga Penutupan Saham BBCA") +
  xlab("Tanggal") +
  ylab("Harga Penutupan (Rp)") +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 15),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


# Uji stasioneritas
acf(ts_bbca, main = "Plot ACF Harga Penutupan Saham BBCA")
pacf(ts_bbca, main = "Plot PACF Harga Penutupan Saham BBCA")
adf.test(ts_bbca)
# Data belum stasioner maka diperlukan differencing

# Differencing 1 kali lalu uji stasioneritas lagi
ts_diff <- diff(ts_bbca)
autoplot(ts_diff) + ggtitle("Deret Waktu Setelah Differencing Harga Penutupan Saham BBCA") + ylab("Difference")

acf(ts_diff, main = "Plot ACF Data Hasil Differencing")
pacf(ts_diff, main = "Plot PACF Data Hasil Differencing")
adf.test(ts_diff)
# Data stasioner setelah differencing 1 kali

# Kandidat model ARIMA
model011 <- Arima(ts_bbca, order = c(0,1,1))
model110 <- Arima(ts_bbca, order = c(1,1,0))
model012 <- Arima(ts_bbca, order = c(0,1,2))
model111 <- Arima(ts_bbca, order = c(1,1,1))
model211 <- Arima(ts_bbca, order = c(2,1,1))
model112 <- Arima(ts_bbca, order = c(1,1,2))

summary(model011)
summary(model110)
summary(model012)
summary(model111)
summary(model211)
summary(model112)

# Diagnostik model
checkresiduals(model012, plot = T)

# Forecasting 14 hari ke depan
forecast_bbca <- forecast(model012, h = 14)
autoplot(forecast_bbca) + ggtitle("Forecast Harga BBCA") + ylab("Harga")


######################################
# Buat data historis dari data asli
data_historis <- data.frame(
  Tanggal = data$Tanggal,
  Harga = data$Terakhir
) %>% filter(Tanggal >= as.Date("2024-07-01"))

# Buat tanggal prediksi
tanggal_terakhir <- max(data$Tanggal)
tanggal_prediksi <- seq(from = tanggal_terakhir + 1, by = "days", length.out = 14)

# Buat data prediksi
df_prediksi <- data.frame(
  Tanggal = tanggal_prediksi,
  Harga = as.numeric(forecast_bbca$mean),
  Lower = as.numeric(forecast_bbca$lower[,2]),
  Upper = as.numeric(forecast_bbca$upper[,2])
)

# Gabungkan data historis dan prediksi untuk plotting
df_plot <- bind_rows(
  data_historis %>% mutate(Tipe = "Aktual"),
  df_prediksi %>% mutate(Tipe = "Prediksi")
)

# Plot
ggplot(df_plot, aes(x = Tanggal, y = Harga, color = Tipe)) +
  geom_line() +
  geom_ribbon(data = df_prediksi,
            aes(x = Tanggal, ymin = Lower, ymax = Upper),
            fill = "blue", alpha = 0.2, inherit.aes = FALSE) +
  labs(title = "Peramalan Harga Saham BBCA (Model ARIMA(0,1,2))",
       x = "Tanggal", y = "Harga") +
  scale_color_manual(values = c("Aktual" = "black", "Prediksi" = "red")) +
  theme_minimal()
######################################



model <- arima(ts_bbca, order = c(4,0,4))
# model2 <- arima(diff(ts_bbca), order = c(0,0,1), include.mean = FALSE)
# 
# summary(model1)
# summary(model2)

# Ambil fitted values (prediksi dalam sample)
prediksi <- fitted(model)

# Plot data aktual
autoplot(ts_bbca, series = "Aktual") +
  autolayer(prediksi, series = "Prediksi", PI = FALSE) +
  ggtitle("Aktual vs Prediksi ARIMA BBCA") +
  xlab("Waktu") + ylab("Harga") +
  scale_color_manual(values = c("Aktual" = "black", "Prediksi" = "blue")) +
  theme_minimal()

auto.arima(ts_bbca, trace = T, approximation = F)