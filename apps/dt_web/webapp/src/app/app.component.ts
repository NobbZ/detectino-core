/*
 * Angular 2 decorators and services
 */
import { Component, ViewEncapsulation, ElementRef, AfterViewInit } from '@angular/core';
import { Router } from '@angular/router';
import { Http } from '@angular/http';
import { Observable } from 'rxjs/Observable';
import { Subscription }   from 'rxjs/Subscription';

import { AuthService } from './services';

import { NotificationService } from './services';

import { Message } from 'primeng/primeng';

declare var Ultima: any;

/*
 * App Component
 * Top Level Component
 *
 * XXX ElementRef is discouraged, check if we can avoid it
 *
 */
@Component({
  selector: 'app',
  encapsulation: ViewEncapsulation.None,
  styles: [
    require('./app.component.css')
  ],
  template: require('./app.component.html')
})

export class AppComponent implements AfterViewInit {
  angularclassLogo = 'assets/img/angularclass-avatar.png';
  loading = false;
  name = 'Detectino';

  subscription: Subscription;

  notifications: Message[] = [];

  constructor(private el: ElementRef, private router: Router, private auth: AuthService,
              private notificationService: NotificationService) {

                this.subscription = notificationService.messages$.subscribe(
                  messages => { this.notifications = messages; console.log(messages); }
                );
  }

  ngAfterViewInit() {
    Ultima.init(this.el.nativeElement);
  }
}
