const express = require('express');
const app = express();
app.get('/health', (_req, res) => res.json({ ok: true, service: 'web' }));
app.listen(process.env.PORT || 3000, () => console.log('Demo web service started'));
