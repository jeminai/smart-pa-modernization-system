import React from 'react';
import ReactDOM from 'react-dom/client';

function App() {
  return (
    <div style={{ textAlign: 'center', padding: 50 }}>
      <h1>🔊 Smart PA System</h1>
      <p>Control and monitor your upgraded public address system.</p>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
