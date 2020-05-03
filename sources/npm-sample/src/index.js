/*
 * Copyright (C) 2007-2020 Crafter Software Corporation. All Rights Reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as published by
 * the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import React from 'react';
import ReactDOM from 'react-dom';
import { setRequestForgeryToken } from '@rart/25d0661d/utils/auth';
import CrafterCMSNextBridge from '@rart/25d0661d/components/CrafterCMSNextBridge';
import AuthMonitor from '@rart/25d0661d/components/SystemStatus/AuthMonitor';
import { validateSession } from '@rart/25d0661d/services/auth';

setRequestForgeryToken();

function renderApp() {
  const App = React.lazy(() => import('./App'));
  const Component = (
    <CrafterCMSNextBridge>
      <App />
      <AuthMonitor />
    </CrafterCMSNextBridge>
  );
  ReactDOM.render(Component, document.getElementById('root'));
  // ReactDOM.createRoot(
  //   document.getElementById('root')
  // ).render(
  //   <React.StrictMode>
  //     <Component />
  //   </React.StrictMode>
  // );
}

if (process.env.NODE_ENV === 'production') {
  renderApp();
} else {
  validateSession().subscribe((active) => {
    if (active) {
      renderApp();
    } else {
      ReactDOM.render(
        <div style={{ margin: '100px auto', textAlign: 'center' }}>
          Please <a
          href={`http://localhost:8080/studio/login?redirect=${encodeURIComponent(window.location.href)}`}
        >login</a> first. Then, <a
          href="/"
          onClick={(e) => {
            e.preventDefault();
            window.location.reload();
          }}
        >refresh this page</a>.
        </div>,
        document.getElementById('root')
      );
    }
  });
}
