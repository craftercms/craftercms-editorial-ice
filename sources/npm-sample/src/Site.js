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
import { capitalize } from '@rart/25d0661d/utils/string';
import { ArrowBackRounded } from '@material-ui/icons';
import IconButton from '@material-ui/core/IconButton';
import Typography from '@material-ui/core/Typography';
import ListItem from '@material-ui/core/ListItem';
import ListItemAvatar from '@material-ui/core/ListItemAvatar';
import Avatar from '@material-ui/core/Avatar';
import ListItemText from '@material-ui/core/ListItemText';
import List from '@material-ui/core/List';
import Component from '@rart/25d0661d/components/Icons/Component';

export default function (props) {
  const {
    siteId,
    onBack,
    classes,
    resource,
    onComponentSelected
  } = props;
  const site = resource.sites.read().find((site) => site.id === siteId);
  const results = resource.components.read();
  return (
    <section className={classes.siteView}>
      <header className={classes.siteViewHeader}>
        <div className={classes.siteViewHeaderMain}>
          <IconButton color="primary" onClick={onBack}>
            <ArrowBackRounded />
          </IconButton>
          <Typography variant="h5" component="h2">{capitalize(site.name)}</Typography>
        </div>
        {
          site.description &&
          <Typography color="textSecondary">{site.description}</Typography>
        }
      </header>
      <Typography variant="subtitle1">
        Showing {results.items.length} of {results.total} components.
      </Typography>
      <List>
        {
          results.items
            .filter((component) =>
              !(component.path.includes('.groovy') || component.path.includes('.level.xml'))
            )
            .map((component) =>
              <ListItem
                button
                divider
                key={component.path}
                onClick={() => onComponentSelected(component)}
              >
                <ListItemAvatar>
                  <Avatar>
                    <Component />
                  </Avatar>
                </ListItemAvatar>
                <ListItemText
                  primary={component.name}
                  secondary={component.path}
                />
              </ListItem>
            )
        }
      </List>
    </section>
  );
}
