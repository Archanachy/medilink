# Change Password Backend Endpoint

## Required Endpoint

The Flutter app is calling the following endpoint that needs to be implemented in the backend:

### Endpoint
```
POST /auth/change-password
```

### Headers
```
Authorization: Bearer <token>
Content-Type: application/json
```

### Request Body
```json
{
  "oldPassword": "string",
  "newPassword": "string"
}
```

### Response (Success - 200)
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

### Response (Error - 401)
```json
{
  "success": false,
  "message": "Current password is incorrect"
}
```

### Response (Error - 400)
```json
{
  "success": false,
  "message": "Invalid password format"
}
```

## Implementation Notes

1. Extract user ID from the JWT token
2. Verify the old password matches the user's current password
3. Validate new password requirements (minimum 8 characters)
4. Ensure new password is different from old password
5. Hash the new password
6. Update the user's password in the database
7. Return appropriate success or error response

## Backend Location
`/Users/archanachaudhary/Documents/Web API /medilink-web-backend/`

## Example Implementation (Node.js/Express)

```javascript
// Route: POST /auth/change-password
router.post('/change-password', authenticateToken, async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;
    const userId = req.user.id; // From JWT token

    // Find user
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    // Verify old password
    const isValidPassword = await bcrypt.compare(oldPassword, user.password);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Current password is incorrect'
      });
    }

    // Validate new password
    if (newPassword.length < 8) {
      return res.status(400).json({
        success: false,
        message: 'Password must be at least 8 characters long'
      });
    }

    // Check if new password is different
    const isSamePassword = await bcrypt.compare(newPassword, user.password);
    if (isSamePassword) {
      return res.status(400).json({
        success: false,
        message: 'New password must be different from current password'
      });
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update password
    user.password = hashedPassword;
    await user.save();

    res.status(200).json({
      success: true,
      message: 'Password changed successfully'
    });
  } catch (error) {
    console.error('Change password error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to change password'
    });
  }
});
```
