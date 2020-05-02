import React, { useEffect, useState } from 'react';
import logo from './logo.svg';
import './App.css';

const fetchSites = () => (
  fetch(`/studio/api/2/users/me/sites?limit=10&offset=0`)
    .then(response => response.json())
    .then(response => response.sites)
);

const fetchUser = () => (
  fetch(`/studio/api/2/users/me.json`)
    .then(response => response.json())
    .then(response => response.authenticatedUser)
);

function App() {

  const [user, setUser] = useState();
  const [sites, setSites] = useState();

  useEffect(() => {
    (async () => {
      const sites = await fetchSites();
      setSites(sites);
    }) ();
    (async () => {
      const user = await fetchUser();
      setUser(user);
    }) ();
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        {
          sites ? (
            sites.length ? <>
              <h2>Hi, {user?.username ?? 'anonymous'}</h2>
              <p>Here are your sites</p>
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
