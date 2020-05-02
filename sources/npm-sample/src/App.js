import React, { Suspense, useCallback, useEffect, useRef, useState } from 'react';
import { fetchSites } from '@rart/25d0661d/services/sites';
import { logout, me } from '@rart/25d0661d/services/auth';
import Link from '@material-ui/core/Link';
import CircularProgress from '@material-ui/core/CircularProgress';
import { HashRouter, Route, Switch, withRouter } from 'react-router-dom';
import SiteList from './SiteList';
import Site from './Site';
import { createResource } from '@rart/25d0661d/utils/hooks';
import { fetchContentType, fetchLegacyContentTypes } from '@rart/25d0661d/services/content';
import { theme } from '@rart/25d0661d/styles/theme';
import { map, switchMap } from 'rxjs/operators';
import { search } from '@rart/25d0661d/services/search';
import { setSiteCookie } from '@rart/25d0661d/utils/auth';
import { useStyles } from './styles';
import { getItem, parseDescriptor } from '@craftercms/content';
import ComponentView from './ComponentView';
import { ThemeProvider } from '@material-ui/core/styles'

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
  getItem(path, { site }).pipe(map(parseDescriptor)).pipe(
    switchMap((item) => fetchContentType(site, item.craftercms.contentTypeId).pipe(
      map((contentType) => ({
        content: item,
        contentType
      }))
    ))
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

  const onLogout = () => logout().toPromise();
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
    <ThemeProvider theme={theme}>
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
    </ThemeProvider>
  );
}

function Loader(props) {
  const { classes } = props;
  return (
    <div className={classes.spinner}>
      <CircularProgress />
    </div>
  );
}

function Header(props) {
  const {
    classes,
    onLogout,
    resource
  } = props;
  const user = resource.read();
  return (
    <header className={classes.header}>
      <h2>Hello, {user?.username ?? 'anonymous'}</h2>
      {
        user &&
        <div className={classes.logoutContainer}>
          <Link onClick={onLogout}>
            Log Out
          </Link>
        </div>
      }
    </header>
  );
}

export default App;
