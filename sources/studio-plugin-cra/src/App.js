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

import React, { useEffect, useState } from 'react';
import logo from './logo.svg';
import './App.css';

const fetchSites = () => (
  fetch(`/studio/api/2/users/me/sites?limit=10&offset=0`)
    .then(response => response.json())
);

function App() {

  const [sites, setSites] = useState();

  useEffect(() => {
    (async () => {
      const response = await fetchSites();
      setSites(response.sites);
    }) ();
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        {
          sites ? (
            sites.length ? <>
              <h2>Your sites</h2>
              <p>{sites.map(site => site.siteId).join(', ')}</p>
            </> : <p>
              You don't have any sites. <a href={`${window.location.origin.replace(window.location.port, '8080')}/studio#/globalMenu/sites`}>Create one</a> to see them here.
            </p>
          ) : (
            <p>Howdy. Retrieving your sites...</p>
          )
        }
      </header>
    </div>
  );
}

export default App;
