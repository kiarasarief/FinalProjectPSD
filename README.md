# "Smart Water Level Monitoring System Using FSM"
---


**Smart Water Level Monitoring System using FSM** adalah sistem berbasis Finite State Machine (FSM) yang diimplentasikan dalam bahasa pemrograman VHDL yang dirancang untuk memantau dan mengontrol ketinggian air dalam tangki secara otomatis. Saat air rendah, pompa aktif mengisi tangki, sementara pada level normal atau tinggi, pompa mati untuk menghemat energi. Dilengkapi dengan kemampuan mendeteksi kondisi kritis dan perhitungan efisiensi pompa. 

### Latar Belakang
Sistem pemantauan tingkat air dalam tangki merupakan aspek krusial dalam berbagai sektor industri, seperti pertanian, perairan, dan pengolahan air, untuk mencegah tumpahan atau kekurangan air yang dapat menyebabkan kerusakan peralatan dan mengganggu proses produksi. Penggunaan teknologi otomatis yang dapat memantau dan mengontrol level air dengan presisi menjadi sangat penting dalam menjaga kestabilan operasi. 

Smart Water Level Monitoring System dirancang sebagai solusi untuk memantau dan mengontrol ketinggian air dalam tangki secara otomatis menggunakan Finite State Machine (FSM). Dengan tiga kategori kondisi air—Low, Normal, dan High—serta empat state utama—Idle, Filling, Full, dan Critical—sistem ini memastikan operasi pompa berjalan efisien dan responsif. Selain mengelola pompa dan alarm secara otomatis, sistem ini juga menghitung efisiensi pompa dan aliran air untuk optimasi operasional. Melalui kombinasi FSM dan logika digital, sistem ini menjadi langkah inovatif dalam mengatasi tantangan pengelolaan air dengan cara yang lebih efisien dan handal.

### Tujuan
Mengotomatiskan kontrol level air dengan memonitor dan mengatur pompa berdasarkan kondisi level air. Sistem ini juga bertujuan mendeteksi kerusakan pompa lebih awal, serta menghitung efisiensi pompa untuk meningkatkan keandalan dan efisiensi operasional. Dengan menggunakan FSM, diharapkan sistem dapat memberikan kontrol yang lebih responsif dan optimal dalam pengelolaan air.

## Implementasi Modul
### Dataflow Style
Dataflow Style memanfaatkan hubungan langsung antara input dan output melalui persamaan logika.

##### Implementasi: 
Tidak secara eksplisit terlihat gaya dataflow pada komponen utama, tetapi pengolahan sinyal sederhana seperti level_tank <= current_level pada Tank mencerminkan hubungan langsung antara input (level) dan output (level_tank).

### Behavorial Style 
Behavioral Style mendeskripsikan perilaku sistem melalui proses yang memanfaatkan logika kontrol.

##### Implementasi: 
- Menggunakan proses berbasis clock dengan logika case untuk menentukan kondisi tangki (LOW, NORMAL, HIGH) serta pengendalian alarm berbasis timer di Tank.vhd. State tangki diproses dalam blok process(clock).
- Menentukan state pompa (MENGISI atau GABUT) menggunakan logika if-else dalam proses berbasis clock (PROCESS(clk, kecepatan_air, luas_pompa, delivery_head)) di Pompa.vhd.
- Mengintegrasikan komponen menggunakan logika process(clk) untuk memantau state pompa (MENGISI atau GABUT) di Top_level.vhd.

### Testbench
Testbench digunakan untuk memverifikasi desain dengan mensimulasikan input dan mencatat output.

##### Implementasi:
Dalam tb.vhd, membuat clock untuk mensimulasikan sinyal jam dengan TbClock, menginisialisasi dan mengubah sinyal input seperti level, temp_input, dan enable_pompa, serta membuka file .txt untuk mencatat nilai efisiensi dan debit selama simulasi menggunakan library TEXTIO.

### Structural Style
Structural Style menghubungkan komponen secara hierarkis untuk membangun sistem.

##### Implementasi:
Dalam Top_level.vhd, komponen Tank dan Pompa diinstansiasi dan dihubungkan menggunakan PORT MAP dan port alarm dijadikan INOUT untuk berfungsi sebagai sinyal penghubung antara Tank dan Pompa.

### Looping Construct
Looping digunakan untuk operasi yang berulang, dalam logika kontrol atau perhitungan.

##### Implementasi:
Dalam Tank.vhd, menggunakan loop untuk menghitung timer alarm selama 5 siklus clock. Dalam Pompa.vhd, tidak secara langsung menggunakan loop, tetapi implementasi iteratif terjadi dalam proses berbasis clock untuk menghitung debit dan efisiensi.

### Procedure, Function And Impure Function
Functions digunakan untuk mempermudah perhitungan spesifik.

##### Implementasi:
Terdapat dalam Pompa.vhd:
- Function calculate_debit untuk menghitung debit berdasarkan luas pompa dan kecepatan air.
- Function calculate_efisiensi untuk menghitung efisiensi pompa berdasarkan rumus fisika dengan mempertimbangkan debit, delivery head, densitas air, dan daya pompa.

### Finite State Machine
FSM adalah inti desain, digunakan untuk mengatur transisi antar state.

##### Implementasi:
- Menggunakan state berbasis case untuk LOW, NORMAL, HIGH, dengan transisi otomatis dan kontrol alarm di Tank.vhd.
- FSM berbasis tipe StateType untuk mengelola state MENGISI dan GABUT, mengatur kondisi pompa aktif atau tidak berdasarkan alarm di Pompa.vhd.
- FSM pada proses process(clk) untuk mengelola transisi state antar komponen di Top_level.vhd.


## Komponen
### Pompa
Komponen ini bertugas mengontrol operasi pengisian air berdasarkan kondisi alarm dari tangki. Pompa akan aktif dalam state MENGISI saat menerima sinyal alarm yang menandakan level air rendah dan akan kembali ke state GABUT ketika level air telah normal atau tinggi. Selain itu, komponen ini menghitung performa pompa dengan menghasilkan nilai debit air (dalam m³/s) dan efisiensi operasional pompa (dalam persen). Perhitungan ini dilakukan dengan mempertimbangkan parameter seperti luas pompa, kecepatan air, delivery head, daya, dan densitas air. Output utama dari komponen ini adalah status pompa (Pump_state), debit air, dan efisiensi, yang digunakan untuk memantau kinerja sistem secara real-time.

### Tangki
Komponen ini bertugas memantau level air dalam tangki, mendeteksi kondisi kritis, dan mengontrol alarm. Dengan tiga level utama—LOW, NORMAL, dan HIGH—tangki menentukan status ketinggian air dan mengaktifkan alarm jika air berada pada level LOW selama lebih dari 5 siklus clock. Output dari tangki mencakup level air (Level_tank), status alarm (Alarm_tank), dan suhu air (Temp), yang semuanya digunakan untuk menginformasikan status kondisi tangki ke komponen lain. Dengan mekanisme berbasis FSM, komponen ini memastikan tangki berfungsi optimal dan responsif terhadap perubahan level air.

### Top-Level 
Komponen ini merupakan komponen utama yang menghubungkan komponen Pompa dan Tangki dalam satu sistem. Memetakan output tangki, seperti alarm dan level air, ke input pompa untuk sinkronisasi operasi. Selain itu, Top-Level memastikan sinyal clock mengatur kedua komponen secara bersamaan. Output dari Top-Level mencakup efisiensi dan debit air, sementara status alarm dan suhu tangki disalurkan untuk pemantauan lebih lanjut.

## Cara Kerja
Sistem ini dimulai dengan menerima beberapa input utama, yaitu level air (00 untuk LOW, 01 untuk NORMAL, 11 untuk HIGH), suhu air, luas pompa, kecepatan air, dan delivery head. Input level air dan suhu diteruskan ke komponen Tangki, sedangkan parameter seperti luas, kecepatan, dan delivery head diberikan ke komponen Pompa bersama sinyal enable (Enable_pompa).

Di dalam **Tangki**, sistem memantau level air dan menentukan statusnya sebagai LOW, NORMAL, atau HIGH. Jika level air berada di LOW (00), tangki akan menunggu selama 5 siklus clock sebelum mengaktifkan alarm untuk memberi sinyal bahwa pompa harus bekerja. Pada level NORMAL (01) atau HIGH (11), alarm akan mati, menandakan bahwa pompa tidak perlu diaktifkan. Selain itu, suhu air diteruskan sebagai output untuk mencatat kondisi tangki secara real-time.

Komponen **Pompa** berfungsi membaca sinyal alarm dari tangki. Jika alarm aktif, pompa akan beralih ke kondisi MENGISI untuk menyalakan pompa dan mengisi air ke tangki. Sebaliknya, ketika alarm mati, pompa kembali ke kondisi GABUT (idle). Pompa juga menghitung debit air berdasarkan luas pompa dan kecepatan air, serta menghitung efisiensi operasinya menggunakan debit, delivery head, densitas air, dan daya pompa. Hasil dari proses ini menjadi output berupa debit air dan efisiensi pompa.

Komponen Top-Level bertindak sebagai penghubung antara tangki dan pompa. Alarm dari tangki diteruskan ke pompa untuk mengontrol statusnya, sementara sinyal clock digunakan untuk menyinkronkan kedua komponen. Output dari Top-Level mencakup level air, suhu tangki, debit air, dan efisiensi pompa, yang menunjukkan kondisi sistem secara keseluruhan.

Terakhir, hasil simulasi dicatat dalam file **.txt** melalui proses yang dilakukan di testbench. File ini mencatat waktu simulasi (Time(ns)), debit air, dan efisiensi pompa menggunakan library TEXTIO di VHDL. Data ini berfungsi sebagai hasil pengujian untuk memastikan bahwa sistem bekerja sesuai desain dan dapat digunakan untuk analisis lebih lanjut.

## Testing
### Sintesis
![picture 0](https://i.imgur.com/8n1CU7w.png)  


### Waveform
![picture 1](https://i.imgur.com/px78TU2.png)  

### .txt
![picture 2](https://i.imgur.com/RHqWmUP.png)  

## Kontributor
- @sleepingpolice-afk
- @esuuun
- @sitiamalianurfaidah
- @kiarasarief 

