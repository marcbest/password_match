<template>
  <div id="guess">
    <navbar-guess></navbar-guess>
    <div class="container">
      <br><br>
      <center><h1>Password Match</h1></center>
      <center><h4>{{ stats }}</h4></center>
      <br>
      <div class="row">
        <div class="col-md-12 col-md-offset-2">
          <form>
            <div class="col-md-6">
              <input type="text" v-model="password" class="form-control" autofocus="true" @keydown.enter.prevent="guessPassword">
              <input type="text" style="display: none;" />
            </div>
            <div class="col-md-6">
              <button type="button" @click="guessPassword()" class="btn btn-primary" :disabled="!password.length">Check</button>
            </div>
          </form>
        </div>
      </div>
      <br>
      <div class="row">
        <div class="col-md-7 col-md-offset-2">
        <center><h4>{{last_searched}}</h4></center>
        <p>{{password_info}}</p>
         <div id="chart"></div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>

import Navbar from '../guess/navbar.vue'

export default {
  name: 'password',
  components: {
    'navbar-guess': Navbar
  },
  data() {
    return {
      password: '',
      last_searched: '',
      password_info: '',
      stats: ''
    }
  },
  mounted: function(){
    this.updateStats() //method1 will execute at pageload
  },
  methods: {
    guessPassword() {
      if (this.password) {
      this.$http.post('/guess', {password: this.password}, {})
        .then((res) => { this.password_info = res.body.result, this.last_searched = this.password, this.password = '' })
        .catch((error) => console.log('Got a problem' + error));
      } else {
        this.password_info = 'Not a valid password'
        this.last_searched = ''
      }

    },
    updateStats: function () {
    this.$http.get('/stats').then((response) => {
        this.stats = response.body.result;
    }, (response) => {
        console.log('ERROR');
        console.log(response);
    });
    setTimeout(this.updateStuff, 5000);
    }
  },
}


</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
