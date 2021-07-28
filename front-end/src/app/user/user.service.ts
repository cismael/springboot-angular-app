import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

// RxJs
import { catchError, map, tap } from 'rxjs/operators';
import { throwError as observableThrowError, Observable, of } from 'rxjs';

// Angular HTTP default options
const httpOptions = { headers: new HttpHeaders({'Content-Type': 'application/json; charset=utf-8'}) };

import { User } from "./user";
import { IUserResponse } from "./user-response-interface";


@Injectable()
export class UserService {

  private apiRoot = 'http://localhost:8081';

  constructor(private http: HttpClient) { }

  findAll(): Observable<IUserResponse[]>  {
    let apiURL = `${this.apiRoot}/users`;
    return this.http.get<IUserResponse[]>(apiURL, httpOptions)
      .pipe(
        tap((usersResponse: IUserResponse[]) => {
            console.log('response message : ' + JSON.stringify(usersResponse));
          }),
        catchError(this.handleError<IUserResponse[]>('gelAllUsers'))
      )
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

  /**
   * Handle Http operation that failed.
   * Let the app continue.
   * @param operation - name of the operation that failed
   * @param result - optional value to return as the observable result
   */
  private handleError<T> (operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {

      // TODO: send the error to remote logging infrastructure
      console.error(error); // log to console instead

      // TODO: better job of transforming error for user consumption
      console.log(`${operation} failed: ${error.message}`);

      // Let the app keep running by returning an empty result.
      return of(result as T);
    };
  }

}
