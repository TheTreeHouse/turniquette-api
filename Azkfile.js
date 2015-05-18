/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */

// Adds the systems that shape your system
systems({
  turniquette: {
    // Dependent systems
    depends: ['mongodb'],
    // More images:  http://images.azk.io
    image: {"dockerfile": "."},
    // Steps to execute before running instances
    provision: [
      "bundle install --path .bundle",
      "bundle exec rake db:migrate",
    ],
    workdir: "/azk/#{manifest.dir}",
    shell: "/bin/bash",
    command: "bundle exec rackup config.ru --pid /tmp/rails.pid --port $HTTP_PORT --host 0.0.0.0",
    wait: {"retry": 20, "timeout": 1000},
    mounts: {
      '/azk/#{manifest.dir}': path("."),
    },
    scalable: {"default": 2},
    http: {
      domains: [ "#{system.name}.#{azk.default_domain}" ]
    },
    envs: {
      // set instances variables
      RUBY_ENV: "development",
      BUNDLE_APP_CONFIG: ".bundle",
    },
  },
  mongodb: {
    image : { docker: "azukiapp/mongodb" },
    scalable: false,
    wait: {"retry": 20, "timeout": 1000},
    // Mounts folders to assigned paths
    mounts: {
      // equivalent persistent_folders
      '/data/db': path('.mongodb'),
    },
    ports: {
      http: "28017:28017/tcp",
    },
    http: {
      // mongodb.azk.dev
      domains: [ "#{system.name}.#{azk.default_domain}" ],
    },
    export_envs: {
      MONGODB_URI: "mongodb://#{net.host}:#{net.port[27017]}/#{manifest.dir}",
      MONGODB_SOCKET: "#{net.host}:#{net.port[27017]}",
    },
  },
});
