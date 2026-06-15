using Domain.Entidades.RegisterRequest;
using Domain.Entidades.ResponseCreate;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Interfaces.RegisterUser
{
    public interface IRegisterUserBLL
    {
        Task<ResponseCreateETL> Register(RegisterRequestETL request);
    }
}
