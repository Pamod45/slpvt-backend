import request from 'supertest';
import app from '../../app.js';
import db from '../../db/postgres.js';

describe('Auth Endpoints (Integration)', () => {
    
    let savedRefreshToken = '';

    afterAll(async () => {
        await db.destroy();
    });

    describe('POST /api/v1/auth/login', () => {

        it('should login successfully with valid seeded credentials', async () => {
            const response = await request(app)
                .post('/api/v1/auth/login')
                .send({
                    badge_number: 'SLP-00001', 
                    password: 'Test@1234'
                });

            expect(response.status).toBe(200);
            expect(response.body).toHaveProperty('access_token');
            expect(response.body).toHaveProperty('refresh_token');
            expect(response.body.user.role).toBe('SUPER_ADMIN');

            savedRefreshToken = response.body.refresh_token;
        });

        it('should fail with 401 for incorrect password', async () => {
            const response = await request(app)
                .post('/api/v1/auth/login')
                .send({
                    badge_number: 'SLP-00001',
                    password: 'WrongPassword123'
                });

            expect(response.status).toBe(401);
            expect(response.body).toHaveProperty('message', 'Invalid badge number or password');
        });

        it('should fail with 422 Unprocessable Entity for missing badge_number', async () => {
            const response = await request(app)
                .post('/api/v1/auth/login')
                .send({
                    password: 'Test@1234'
                });

            expect(response.status).toBe(422);
            expect(response.body).toHaveProperty('message', 'Validation failed');
            expect(response.body).toHaveProperty('errors');
            expect(response.body.errors[0]).toHaveProperty('message', 'Badge number is required');
        });
    });

    describe('POST /api/v1/auth/refresh', () => {
        
        it('should generate a new access token using a valid refresh token', async () => {
            const response = await request(app)
                .post('/api/v1/auth/refresh')
                .send({
                    refresh_token: savedRefreshToken
                });

            expect(response.status).toBe(200);
            expect(response.body).toHaveProperty('access_token');
            expect(response.body).toHaveProperty('refresh_token'); 
            
            savedRefreshToken = response.body.refresh_token;
        });

        it('should fail with 401 for an invalid or missing refresh token', async () => {
            const response = await request(app)
                .post('/api/v1/auth/refresh')
                .send({
                    refresh_token: 'invalid_refresh_token_string'
                });

            expect(response.status).toBe(401);
        });
    });

    describe('POST /api/v1/auth/logout', () => {

        it('should logout successfully when provided a refresh token', async () => {
            const response = await request(app)
                .post('/api/v1/auth/logout')
                .send({
                    refresh_token: savedRefreshToken
                });

            expect(response.status).toBe(204);
            expect(response.body).toEqual({});
        });
        
        it('should not allow refreshing after logging out', async () => {
            const response = await request(app)
                .post('/api/v1/auth/refresh')
                .send({
                    refresh_token: savedRefreshToken
                });

            expect(response.status).toBe(401); 
        });

    });

});
