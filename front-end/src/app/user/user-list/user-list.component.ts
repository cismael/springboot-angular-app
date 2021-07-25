import { Component, OnInit } from '@angular/core';
import { UserService } from "../user.service";
import { Router } from '@angular/router';

import { User } from "../user";


@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.css'],
  providers: [UserService]
})
export class UserListComponent implements OnInit {

  public users: User[] = [];

  constructor(private router: Router,
              private userService: UserService) { }

  ngOnInit() {
    this.getAllUsers();
  }

  private getAllUsers() {
    this.userService.findAll()
      .subscribe(
        response => {
          for (let i=0; i<= response.length; i++) {
            this.users.push(new User(response[i].id, response[i].firstName, response[i].lastName, response[i].email));
          }
          console.log(this.users);
        },
        error => {
          console.log(error);
        }
      );
  }

  public redirectNewUserPage() {
    this.router.navigate(['/user/create']);
  }

  public editUserPage(user: User) {
    if (user) {
      this.router.navigate(['/user/edit', user.id]);
    }
  }

  public deleteUser(user: User) {
    console.log('Delete User');
  }

}
