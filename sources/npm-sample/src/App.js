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

import React, { Suspense, useCallback, useEffect, useRef, useState } from 'react';
import { fetchSites } from '@rart/25d0661d/services/sites';
import { logout } from '@rart/25d0661d/services/auth';
import { HashRouter, Route, Switch, withRouter } from 'react-router-dom';
import SiteList from './SiteList';
import Site from './Site';
import { createResource } from '@rart/25d0661d/utils/hooks';
import {
  fetchContentType,
  fetchLegacyContentTypes,
  getLegacyItem
} from '@rart/25d0661d/services/content';
import { map, switchMap } from 'rxjs/operators';
import { search } from '@rart/25d0661d/services/search';
import { setSiteCookie } from '@rart/25d0661d/utils/auth';
import { useStyles } from './styles';
import { getItem, parseDescriptor } from '@craftercms/content';
import ComponentView from './ComponentView';
import Loader from './Loader';
import Header from './Header';
import { forkJoin } from 'rxjs';
import { me } from '@rart/25d0661d/services/users';

const createUserResource = () => createResource(() => me().toPromise());
const createSitesResource = () => createResource(() => fetchSites().toPromise());
const createComponentsResource = (site) => createResource(() =>
  fetchLegacyContentTypes(site).pipe(
    map((contentTypes) =>
      contentTypes.filter((contentType) => contentType.type === 'component')
    ),
    switchMap((contentTypes) => search(site, {
      query: '',
      keywords: '',
      offset: 0,
      limit: 10,
      sortBy: '_score',
      sortOrder: 'desc',
      filters: {
        'content-type': contentTypes.map((contentType) => contentType.name)
      }
    }))
  ).toPromise()
);
const createComponentResource = (site, path) => createResource(() =>
  forkJoin([
    getLegacyItem(site, path),
    getItem(path, { site }).pipe(map(parseDescriptor)).pipe(
      switchMap((item) => fetchContentType(site, item.craftercms.contentTypeId).pipe(
        map((contentType) => ({
          content: item,
          contentType
        }))
      ))
    )
  ]).pipe(
    map(([item, resource]) => ({ ...resource, item }))
  ).toPromise()
);

const RouteMonitor = withRouter(function (props) {
  const { onChange, history, location, match } = props;
  const ref = useRef();
  // noinspection JSValidateTypes
  ref.current = { history, location, match };
  useEffect(() => {
    onChange(ref.current);
  }, [onChange, props.location.pathname]);
  return null;
});

const neverResource = createResource(() => new Promise(() => void 0));
const initialSiteResource = createSitesResource();
const initialUserResource = createUserResource();

function App() {

  const classes = useStyles();
  const [userResource] = useState(initialUserResource);
  const [sitesResource, setSitesResource] = useState(initialSiteResource);
  const [componentsResource, setComponentsResource] = useState(neverResource);
  const [componentResource, setComponentResource] = useState(neverResource);

  const onLogout = () => logout().subscribe(() => {
    window.location.reload();
  });
  const onRefreshSites = () => setSitesResource(createSitesResource);
  const onRouteChange = useCallback((props) => {
    const { match: { params } } = props;
    setSiteCookie('crafterSite', params.siteId);
    if (params.path) {
      setComponentResource(() => createComponentResource(params.siteId, decodeURIComponent(params.path)));
    } else if (params.siteId) {
      setComponentsResource(() => createComponentsResource(params.siteId));
    }
  }, []);

  return (
    <section className={classes.root}>
      <Suspense fallback={<Loader classes={classes} />}>
        <Header classes={classes} resource={userResource} onLogout={onLogout} />
      </Suspense>
      <HashRouter>
        <Switch>
          <Route
            path="/:siteId/:path"
            render={({ history, match: { params } }) =>
              <>
                <RouteMonitor onChange={onRouteChange} />
                <Suspense fallback={<Loader classes={classes} />}>
                  <ComponentView
                    siteId={params.siteId}
                    classes={classes}
                    onBack={() => history.push(`/${params.siteId}`)}
                    path={decodeURIComponent(params.path)}
                    resource={componentResource}
                  />
                </Suspense>
              </>
            }
          />
          <Route
            path="/:siteId"
            render={({ history, match: { params } }) =>
              <>
                <RouteMonitor onChange={onRouteChange} />
                <Suspense fallback={<Loader classes={classes} />}>
                  <Site
                    classes={classes}
                    onBack={() => history.push('/')}
                    siteId={params.siteId}
                    onComponentSelected={(component) => history.push(`/${params.siteId}/${encodeURIComponent(component.path)}`)}
                    resource={{
                      sites: sitesResource,
                      components: componentsResource
                    }}
                  />
                </Suspense>
              </>
            }
          />
          <Route
            exact
            path="/"
            render={(props) =>
              <>
                <RouteMonitor onChange={onRouteChange} />
                <Suspense fallback={<Loader classes={classes} />}>
                  <SiteList
                    classes={classes}
                    resource={sitesResource}
                    onRefreshSites={onRefreshSites}
                    onSiteSelected={(site) => props.history.push(`/${site.id}`)}
                  />
                </Suspense>
              </>
            }
          />
        </Switch>
      </HashRouter>
    </section>
  );
}

export default App;
