const express = require('express');
const multer = require('multer');
const app = express();
const PORT = 3000;

// Set up multer for handling file uploads
const upload = multer({ dest: 'uploads/' }); // The directory where files are saved

// Handle file upload
app.post('/upload-image', upload.single('image'), (req, res) => {
  if (req.file) {
    console.log('File uploaded:', req.file);
    res.status(200).json({ message: 'File uploaded successfully' });
  } else {
    res.status(400).json({ message: 'File upload failed' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
