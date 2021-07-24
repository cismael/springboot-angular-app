import { Injectable } from '@angular/core';
import { User } from "./user";
import { Http, Response } from "@angular/http";
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError, map, tap catch } from 'rxjs/operators';
import {throwError as observableThrowError,  Observable, of } from 'rxjs';


// Angular HTTP default options
const httpOptions = { headers: new HttpHeaders({'Content-Type': 'application/json; charset=utf-8'}) };


@Injectable()
export class UserService {

  private apiUrl = 'http://localhost:8080/users';

  constructor(private http: HttpClient) { }

  findAll(): Observable<User[]>  {
    return this.http.get(this.apiUrl)
//       .pipe(
//         tap((message: IMessageResponse) => {
//             console.log('response message : ' + JSON.stringify(message));
//           }),
//         catchError(this.handleError<IMessageResponse>('sendMail'))
//       );
      .map((res:Response) => res.json())
      .catch((error:any) => observableThrowError(error.json().error || 'Server error'));
  }

  findById(id: number): Observable<User> {
    return null;
  }

  saveUser(user: User): Observable<User> {
    return null;
  }

  deleteUserById(id: number): Observable<boolean> {
    return null;
  }

  updateUser(user: User): Observable<User> {
    return null;
  }

}
