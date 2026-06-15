using Application.Interfaces.Login;
using Application.Interfaces.Token;
using BCrypt.Net;
using Domain.Entidades.LoginResponse;
using Domain.Entidades.UserInfo;
using Domain.Interfaces.GetUserByEmail;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Servicios.Login
{
    public class LoginBLL : ILoginBLL
    {
        private readonly IGetUserByEmailDAL _getUserByEmailDAL;
        private readonly ITokenBLL _generateTokenBLL;

        public LoginBLL(IGetUserByEmailDAL getUserByEmailDAL, ITokenBLL generateTokenBLL)
        {
            _getUserByEmailDAL = getUserByEmailDAL;
            _generateTokenBLL = generateTokenBLL;
        }

        public async Task<LoginResponseETL> Login(string email, string password)
        {
            try
            {
                var user = await _getUserByEmailDAL.GetUserByEmail(email);

                if (user == null)
                {
                    return new LoginResponseETL
                    {
                        Success = false,
                        Message = "Usuario no encontrado"
                    };
                }

                if (!BCrypt.Net.BCrypt.Verify(password, user.PasswordHash))
                {
                    return new LoginResponseETL
                    {
                        Success = false,
                        Message = "Contraseña incorrecta"
                    };
                }

                var token = _generateTokenBLL.GenerateToken(user);

                return new LoginResponseETL
                {
                    Success = true,
                    Token = token,
                    Message = "Login exitoso",
                    User = new UserInfoETL
                    {
                        UserId = user.UserId,
                        Name = user.Name,
                        Email = user.Email,
                        Role = user.Role,
                        Phone = user.Phone
                    }
                };
            }
            catch (Exception ex)
            {
                return new LoginResponseETL
                {
                    Success = false,
                    Message = "Error interno del servidor"
                };
            }
        }
    }
}
