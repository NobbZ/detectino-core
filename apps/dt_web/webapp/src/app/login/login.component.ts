import { Component } from '@angular/core';
import { AuthService } from '../services';

@Component({
  selector: 'login',
  template: require('./login.template.html')
})

export class Login {
  constructor(public auth: AuthService) {
  }

  login(event: Event, username: string, password: string) {
    event.preventDefault();
    this.auth.login(username, password).
      subscribe( res => {
      if (res) {
        // this.router.parent.navigate(['Home']);
      } else {
        console.log('ayee cannot log');
      }
    }, error => console.log('ayeee error in log'));
  }
}
