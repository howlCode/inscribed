import Vue from "vue";
import App from "./App";
import router from "./router";
import VueAxios from "vue-axios";
import { securedAxiosInstance, plainAxiosInstance } from "./backend/axios";
require("./assets/sass/main.scss");

Vue.config.productionTip = false;
Vue.use(VueAxios, {
  secured: securedAxiosInstance,
  plain: plainAxiosInstance
});

/* eslint-disable no-new */
new Vue({
  el: "#app",
  router,
  securedAxiosInstance,
  plainAxiosInstance,
  components: { App },
  template: "<App/>"
});
