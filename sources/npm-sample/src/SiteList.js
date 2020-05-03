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
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemAvatar from '@material-ui/core/ListItemAvatar';
import Avatar from '@material-ui/core/Avatar';
import { RefreshRounded, WorkRounded } from '@material-ui/icons';
import ListItemText from '@material-ui/core/ListItemText';
import IconButton from '@material-ui/core/IconButton';
import Typography from '@material-ui/core/Typography';

export default function (props) {
  const { resource, classes, onSiteSelected, onRefreshSites } = props;
  const sites = resource.read();
  return (
    <div className={classes.mainContent}>
      <header className={classes.siteViewHeader}>
        <div className={classes.siteViewHeaderMain}>
          <Typography variant="h5" component="h2">
            Sites
          </Typography>
        </div>
        <Typography color="textSecondary">You have {sites.length} sites</Typography>
      </header>
      <List className={classes.root}>
        {
          sites.map(site =>
            <ListItem
              button
              divider
              key={site.id}
              onClick={() => onSiteSelected?.(site)}
            >
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
      <IconButton variant="contained" color="primary" onClick={onRefreshSites}>
        <RefreshRounded />
      </IconButton>
    </div>
  );
}
