# Todo Application

<div style="background-color:#f0f0f0; padding:10px; border-radius:5px;">
  <h2>Gambaran Umum</h2>
  <p>Aplikasi Todo ini adalah proyek full-stack yang digunakan untuk mengelola daftar tugas. Backend dibangun dengan <strong>Node.js</strong>, <strong>Express</strong>, dan <strong>MongoDB</strong>, sedangkan frontend dikembangkan menggunakan <strong>Flutter</strong>. Aplikasi ini memungkinkan pengguna untuk melakukan operasi CRUD (Create, Read, Update, Delete) pada tugas.</p>
</div>

## 🚀 Fitur
- ✅ **Operasi CRUD:** Tambah, lihat, perbarui, dan hapus tugas.
- 💾 **Integrasi MongoDB:** Penyimpanan data tugas yang persisten.
- 🌐 **API RESTful:** Backend menggunakan API RESTful dengan Express.
- 📱 **Flutter Frontend:** Antarmuka pengguna yang responsif dan interaktif.
- 💻 **Cross-Platform:** Aplikasi dapat dijalankan di Android dan iOS.

## Teknologi yang Digunakan

<table>
  <thead>
    <tr>
      <th>Bagian</th>
      <th>Teknologi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Backend</td>
      <td>Node.js, Express, MongoDB, Mongoose, CORS</td>
    </tr>
    <tr>
      <td>Frontend</td>
      <td>Flutter, Dart, dotenv</td>
    </tr>
    <tr>
      <td>Alat Lain</td>
      <td>Postman, Git, GitHub</td>
    </tr>
  </tbody>
</table>

# Cara Menjalankan Proyek

<div align="center">
  <h2 style="border-bottom: 2px solid #e1e4e8; padding-bottom: 10px;">Backend</h2>
</div>

<div style="margin-left: 20px;">
  <ol>
    <li>
      <strong>Clone</strong> repositori dan navigasikan ke direktori <code>todo_api</code>:
      <pre style="background-color: #f6f8fa; padding: 10px; border-radius: 5px;">
<code style="color: #c7254e; background-color: #f9f2f4;">git clone &lt;repository-url&gt;</code><br>
<code style="color: #c7254e; background-color: #f9f2f4;">cd todo_api</code>
      </pre>
    </li>
    <li>
      <strong>Install dependensi</strong> yang diperlukan:
      <pre style="background-color: #f6f8fa; padding: 10px; border-radius: 5px;">
<code style="color: #c7254e; background-color: #f9f2f4;">npm install</code>
      </pre>
    </li>
    <li>
      <strong>Buat file <code>.env</code></strong> di direktori <code>todo_api</code> dan tambahkan URI MongoDB Anda:
      <pre style="background-color: #f6f8fa; padding: 10px; border-radius: 5px;">
<code style="color: #c7254e; background-color: #f9f2f4;">MONGO_URI=&lt;your_mongodb_connection_string&gt;</code>
      </pre>
    </li>
    <li>
      <strong>Mulai server</strong>:
      <pre style="background-color: #f6f8fa; padding: 10px; border-radius: 5px;">
<code style="color: #c7254e; background-color: #f9f2f4;">npm run dev</code><br>
<code style="color: #c7254e; background-color: #f9f2f4;">node index.js</code>
      </pre>
      Server akan berjalan di <a href="http://localhost:5001" style="color: #0366d6;">http://localhost:5001</a>.
    </li>
  </ol>
</div>

<hr style="border: none; border-top: 2px solid #e1e4e8; margin: 20px 0;" />

<div align="center">
  <h2 style="border-bottom: 2px solid #e1e4e8; padding-bottom: 10px;">Frontend</h2>
</div>

<div style="margin-left: 20px;">
  <ol>
    <li>
      <strong>Navigasikan</strong> ke direktori <code>todo_app</code>:
      <pre style="background-color: #f6f8fa; padding: 10px; border-radius: 5px;">
<code style="color: #c7254e; background-color: #f9f2f4;">cd todo_app</code>
      </pre>
    </li>
    <li>
      Pastikan <strong>Flutter</strong> sudah terpasang di komputer Anda.
    </li>
    <li>
      <strong>Install dependensi</strong>:
      <pre style="background-color: #f6f8fa; padding: 10px; border-radius: 5px;">
<code style="color: #c7254e; background-color: #f9f2f4;">flutter pub get</code>
      </pre>
    </li>
    <li>
      <strong>Jalankan aplikasi</strong> menggunakan:
      <pre style="background-color: #f6f8fa; padding: 10px; border-radius: 5px;">
<code style="color: #c7254e; background-color: #f9f2f4;">flutter run</code>
      </pre>
    </li>
  </ol>
</div>
