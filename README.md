# Analisis Runtun Waktu Harga Saham BBCA dengan Model ARIMA

Projek akhir mata kuliah **Analisis Runtun Waktu** — menganalisis dan meramalkan harga penutupan saham PT Bank Central Asia Tbk (BBCA) menggunakan model Autoregressive Integrated Moving Average (ARIMA) dengan pendekatan Box-Jenkins.

## Tentang Projek

Projek ini dibangun untuk memenuhi tugas akhir semester mata kuliah Analisis Runtun Waktu, di bawah bimbingan:

- **Dra. Widyanti Rahayu, M.Si**
- **Dania Siregar, S.Stat., M.Si**

Data harga saham BBCA dianalisis menggunakan pendekatan statistik time series untuk mengidentifikasi pola pergerakan harga dan membuat peramalan jangka pendek (14 hari ke depan).

## Tools & Libraries

| Tool/Library | Fungsi |
|---|---|
| **R** | Bahasa pemrograman utama |
| `forecast` | Pemodelan ARIMA dan peramalan |
| `tseries` | Uji stasioneritas (ADF test) |
| `ggplot2` | Visualisasi data |
| `dplyr` | Manipulasi data |

## Struktur Projek

```
├── R BBCA.R                                          # Script utama analisis ARIMA
├── Data Historis BBCA.csv                             # Dataset harga saham (lokal)
├── Bagus Arya Dwipangga_1314623042_Tugas Projek ARW Final.pdf   # Laporan lengkap
└── README.md
```

> **Catatan:** File `Data Historis BBCA.csv` tidak di-upload ke repo karena ukuran file. Data dapat diunduh dari [Investing.com](https://id.investing.com/equities/bnk-central-as-historical-data).

## Cara Menjalankan

1. **Install R** dan RStudio (opsional) di komputer Anda
2. **Install library** yang dibutuhkan:
   ```r
   install.packages(c("forecast", "tseries", "ggplot2", "dplyr"))
   ```
3. **Siapkan data** — letakkan file `Data Historis BBCA.csv` di direktori yang sama dengan script
4. **Jalankan script** `R BBCA.R` secara berurutan dari awal hingga akhir

## Hasil Utama

- **Model terbaik:** ARIMA(0, 1, 2)
  - AIC: **13.301,25** | BIC: **13.316,18** (terendah di antara 6 kandidat model)
- **Parameter model:** MA(1) = -0,1792 | MA(2) = -0,0796
- **Validasi:** Residual bersifat white noise (Ljung-Box p-value = 0,8135)
- **Peramalan:** Harga BBCA diprediksi stabil di kisaran **Rp 8.740** selama 14 hari ke depan dengan interval kepercayaan 95%

## Laporan Lengkap

Laporan lengkap beserta tinjauan pustaka, metodologi, hasil, dan pembahasan terdapat pada file:

[`Bagus Arya Dwipangga_1314623042_Tugas Projek ARW Final.pdf`](Bagus%20Arya%20Dwipangga_1314623042_Tugas%20Projek%20ARW%20Final.pdf)

## Penulis

**Bagus Arya Dwipangga** (1314623042)
Program Studi Statistika — Fakultas Matematika dan Ilmu Pengetahuan Alam
Universitas Negeri Jakarta — 2025
