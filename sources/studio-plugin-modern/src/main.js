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

import React, { useState, useEffect } from 'react';
import { render } from 'react-dom';
import { makeStyles, ThemeProvider } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import { components, services, system, util } from '@craftercms/studio';
import ListItem from '@material-ui/core/ListItem';
import ListItemAvatar from '@material-ui/core/ListItemAvatar';
import Avatar from '@material-ui/core/Avatar';
import ListItemText from '@material-ui/core/ListItemText';
import WorkRounded from '@material-ui/icons/WorkRounded';
import List from '@material-ui/core/List';
import Link from '@material-ui/core/Link';

const { CrafterCMSNextBridge, AuthMonitor } = components;

const useStyles = makeStyles(() => ({
  '@global': {
    'html, body': {
      background: '#f3f3f3',
      fontFamily: '"Source Sans Pro", "Open Sans", sans-serif'
    }
  },
  root: {
    textAlign: 'center'
  },
  logoutContainer: {
    margin: '1em 0'
  },
  mainContent: {
    maxWidth: 300,
    margin: 'auto'
  }
}));

function App() {
  return (
    <>
      <CrafterCMSNextBridge>
        <UI />
      </CrafterCMSNextBridge>
    </>
  );
}

function UI() {

  const classes = useStyles();
  const [active, setActive] = useState(true);
  const [sites, setSites] = useState(null);
  const [user, setUser] = useState(null);

  const loadSites = () => services.sites.fetchSites().subscribe(setSites);
  const logout = () => services.auth.logout().subscribe(() => {
    setUser(null);
    setActive(false);
  });

  useEffect(() => {
    services.auth.me().subscribe(setUser);
  }, []);

  return (
    <>
      <section className={classes.root}>
        <h2>Hello, {user?.username ?? 'anonymous'}</h2>
        {
          user &&
          <div className={classes.logoutContainer}>
            <Link onClick={logout}>
              Log Out
            </Link>
          </div>
        }
        {
          sites ? (
            <>
              <div className={classes.mainContent}>
                <List className={classes.root}>
                  {
                    sites.map(site =>
                      <ListItem key={site.id} divider>
                        <ListItemAvatar>
                          <Avatar>
                            <WorkRounded />
                          </Avatar>
                        </ListItemAvatar>
                        <ListItemText
                          primary={site.name}
                          secondary={site.description ?? '(no description)'}
                        />
                      </ListItem>
                    )
                  }
                </List>
              </div>
            </>
          ) : (
            active ? (
              <Button variant="contained" color="primary" onClick={loadSites}>
                Load Sites
              </Button>
            ) : (
              <Typography variant="body">
                Your session expired.
              </Typography>
            )
          )
        }
      </section>
      <AuthMonitor />
    </>
  );
}

function main({ element }) {
  render(<App />, element);
}

export default main;
