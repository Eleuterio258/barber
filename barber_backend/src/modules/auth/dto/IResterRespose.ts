interface IRegisterResponse {
    message: string;
    'X-Hasura-User-Id': string;
    token: string;
}

export default IRegisterResponse