import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { setRequestForgeryToken } from '@rart/25d0661d/utils/auth';

setRequestForgeryToken();

ReactDOM.createRoot(
  document.getElementById('root')
).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
