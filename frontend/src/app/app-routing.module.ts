import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Components
import { UserListComponent } from './user/user-list/user-list.component';
import { UserCreateComponent } from './user/user-create/user-create.component';

// Routes
const routes: Routes = [
  { path: '', redirectTo: 'user-list', pathMatch: 'full' },
  { path: 'user-list', component: UserListComponent },
  { path: 'user/create', component: UserCreateComponent },
  { path: 'user/edit', component: UserCreateComponent },
  { path: '**', redirectTo: '/', pathMatch: 'full' }  // Wildcard route for a 404 page
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
