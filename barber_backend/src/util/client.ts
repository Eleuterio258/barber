import { GraphQLClient } from "graphql-request";

export const client = new GraphQLClient("http://localhost:8080/v1/graphql", {
    headers: { "x-hasura-admin-secret": "LmfNfwt0e2GnHhTKygeYcSZz7Kmdsy1x" },
});


