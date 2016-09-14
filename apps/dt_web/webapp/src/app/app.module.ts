import { NgModule, ApplicationRef } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { HttpModule, JsonpModule, Http } from '@angular/http';
import { RouterModule, Router } from '@angular/router';

import { AuthConfig, AuthHttp } from 'angular2-jwt';

import { ENV_PROVIDERS } from './environment';
import { ROUTES } from './app.routes';
import { AppComponent }   from './app.component';

import { ButtonModule, ToolbarModule, MessagesModule, GrowlModule,
  DialogModule, InputTextModule, DropdownModule, PasswordModule,
  DataTableModule
  } from 'primeng/primeng';

import { AuthService, NotificationService,
  UserService, SensorService } from './services';
import { AuthGuard } from './services/auth.guard';

import { Home } from './home';
import { Login } from './login';
import { Users } from './users';
import { Sensors } from './sensors';

// Application wide providers
const APP_PROVIDERS = [
  {
    provide: AuthService,
    useClass: AuthService,
    deps: [Http, Router]
  },
  NotificationService,
  UserService,
  SensorService,
  AuthGuard,
  { provide: AuthHttp,
    useFactory: (http) => {
      return new AuthHttp(new AuthConfig({
        tokenName: 'id_token',
        noTokenScheme: true,
        globalHeaders: [
          {'Accept': 'application/json'},
          {'Content-Type': 'application/json'}
        ],
        noJwtError: false
      }), http);
    },
    deps: [Http]
  }
];

@NgModule({
  declarations: [
    AppComponent,
    Home,
    Login,
    Users,
    Sensors
  ],
  imports: [ BrowserModule,
    ButtonModule, ToolbarModule, MessagesModule, GrowlModule,
    DialogModule, InputTextModule, DropdownModule, PasswordModule,
    DataTableModule,
    FormsModule,
    HttpModule,
    JsonpModule,
    RouterModule.forRoot(ROUTES)
  ],
  providers: [
    ENV_PROVIDERS,
    APP_PROVIDERS
  ],
  bootstrap: [ AppComponent ]
})

export class AppModule {
}

