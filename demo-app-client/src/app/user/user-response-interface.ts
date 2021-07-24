// Interface servant à mapper le type du retour du HTTP POST
export interface IUserResponse {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
}
