const docsSidebar = [
  {
    text: "About {{project_name}}",
    collapsible: true,
    items: [
      { text: "Changelog", link: "/CHANGELOG" },
      { text: "Contributing", link: "/docs/CONTRIBUTING" },
      { text: "Security policy", link: "/docs/SECURITY" },
      { text: "License", link: "/LICENSE" },
    ],
  },
];

const config: import("vitepress").UserConfig = {
  lang: "en-US",
  title: "{{project_name}}",
  description: "{{project_tagline}}",

  // Because we run vitepress from the root directory, we use a "whitelist" mode:
  // Exclude all files except those specified here
  srcExclude: ["!(docs/**|(index|README|CHANGELOG|LICENSE).md)"],

  themeConfig: {
    nav: [
      {
        text: "Documentation",
        link: "/README",
        activeMatch: "(README|LICENSE|/docs/)",
      },
      { text: "Changelog", link: "/CHANGELOG" },
    ],

    socialLinks: [
      {
        icon: "github",
        link: "https://github.com/{{repo_owner}}/{{repo_name}}",
      },
    ],

    sidebar: {
      "/docs/": docsSidebar,
      "/README": docsSidebar,
      "/CHANGELOG": docsSidebar,
      "/LICENSE": docsSidebar,
    },

    lastUpdated: true,
    editLink: {
      repo: "{{repo_owner}}/{{repo_name}}",
      text: "Edit this page on GitHub",
    },

    footer: {
      message: "Released under the Apache 2.0 License.",
      copyright:
        "Copyright © 2022-present {{author_name}} and the contributors of {{project_name}}",
    },
  },
};

export default config;
