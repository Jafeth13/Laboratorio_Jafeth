using Application.Interfaces.RegisterUser;
using BCrypt.Net;
using Domain.Entidades.RegisterRequest;
using Domain.Entidades.ResponseCreate;
using Domain.Entidades.User;
using Domain.Interfaces.RegisterUser;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Servicios.RegisterUser
{
    public class RegisterUserBLL : IRegisterUserBLL
    {
        private readonly IRegisterUserDAL _userDAL;
        public RegisterUserBLL(IRegisterUserDAL registerUser)
        {
            _userDAL = registerUser;
        }
        public async Task<ResponseCreateETL> Register(RegisterRequestETL request)
        {
            var user = new UserETL
            {
                Name = request.Name,
                Email = request.Email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
                Role = request.Role,
                Phone = request.Phone
            };

            return await _userDAL.Register(user);
        }
    }
}
