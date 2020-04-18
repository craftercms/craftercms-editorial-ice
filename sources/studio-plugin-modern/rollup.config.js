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

import commonjs from 'rollup-plugin-commonjs';
import babel from 'rollup-plugin-babel';
import resolve from 'rollup-plugin-node-resolve';
import replace from 'rollup-plugin-replace';
// If using the watch, you could also use these two in conjunction
// to build, copy and commit so you can refresh browser and see changes.
// import commit from 'rollup-plugin-commit';
// import copy from 'rollup-plugin-copy';

// Used to generate umd build
// import pkg from './package.json';

const plugins = [
  replace({ 'process.env.NODE_ENV': '"production"' }),
  babel({
    exclude: 'node_modules/**',
    presets: [
      '@babel/preset-env',
      '@babel/preset-react'
    ],
    plugins: [
      'babel-plugin-transform-react-remove-prop-types',
      '@babel/plugin-proposal-nullish-coalescing-operator',
      '@babel/plugin-proposal-optional-chaining'
    ]
  }),
  resolve(),
  commonjs({
    include: /node_modules/,
    namedExports: {
      'react-is': ['isValidElementType', 'ForwardRef', 'Memo'],
      'prop-types': ['elementType'],
    }
  }),
  // If using the watch, you could also use these two in conjunction
  // to build, copy and commit so you can refresh browser and see changes.
  // copy({
  //   targets: [{ src: 'build/*', dest: '../../config/studio/plugins/apps/modern' }],
  //   hook: 'writeBundle'
  // }),
  // commit({
  //   targets: [
  //     '../../config/studio/plugins/apps/modern/modern.umd.js',
  //     '../../config/studio/plugins/apps/modern/index.js'
  //   ]
  // })
];

const external = [
  'rxjs',
  'rxjs/operators',
  'react',
  'react-dom',
  'CrafterCMSNext',
  '@craftercms/studio'
];

const globals = {
  'rxjs': 'window.CrafterCMSNext.rxjs',
  'rxjs/operators': 'window.CrafterCMSNext.rxjs.operators',
  'react': 'window.CrafterCMSNext.React',
  'react-dom': 'window.CrafterCMSNext.ReactDOM',
  'CrafterCMSNext': 'window.CrafterCMSNext',
  '@craftercms/studio': 'window.CrafterCMSNext'
};

export default [

  // browser-friendly UMD build
  // {
  //   input: 'src/main.js',
  //   external,
  //   output: {
  //     sourcemap: 'inline',
  //     name: 'studioPluginSample',
  //     file: pkg.browser,
  //     format: 'umd',
  //     amd: {
  //       id: pkg.craftercms.id
  //     },
  //     globals
  //   },
  //   plugins
  // },

  {
    input: 'src/index.js',
    external,
    output: {
      sourcemap: 'inline',
      name: 'studioPluginSample',
      file: 'build/index.js',
      format: 'iife',
      globals
    },
    plugins
  },

];
