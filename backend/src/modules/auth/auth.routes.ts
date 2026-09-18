import { Router } from 'express';
import { authController } from './auth.controller';
import { authMiddleware } from '../../common/auth/middleware';
import { validateBody } from '../../common/validation/middleware';
import { registerSchema, loginSchema, refreshTokenSchema, forgotPasswordSchema, resetPasswordSchema } from '../../common/validation';

const router = Router();

router.post('/register', validateBody(registerSchema), authController.register);
router.post('/login', validateBody(loginSchema), authController.login);
router.post('/refresh', validateBody(refreshTokenSchema), authController.refresh);
router.post('/logout', validateBody(refreshTokenSchema), authController.logout);
router.post('/forgot-password', validateBody(forgotPasswordSchema), authController.forgotPassword);
router.post('/reset-password', validateBody(resetPasswordSchema), authController.resetPassword);

router.get('/me', authMiddleware, authController.me);
router.patch('/me', authMiddleware, authController.updateMe);

export default router;