exports.config = {
  // If these are blank, Protractor will try to protract locally
  sauceUser: process.env.SAUCE_USERNAME,
  sauceKey: process.env.SAUCE_ACCESS_KEY,

  // Desired Caps, as see on our desired capabilities page
  capabilities: {
    os: 'Windows 7',
    browserName: 'Internet Explorer',
    browserVersion: '10'
  },

  // Array of files to run
  specs: ['spec.js']
};