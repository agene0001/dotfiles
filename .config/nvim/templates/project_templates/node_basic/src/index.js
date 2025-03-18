/**
 * @file Main application entry point
 * @author {{_author_}}
 * @email {{_email_}}
 * @date {{_date_}}
 */

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

{{_cursor_}}

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
