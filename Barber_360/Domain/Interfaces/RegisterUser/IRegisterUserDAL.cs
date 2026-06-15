using Domain.Entidades.ResponseCreate;
using Domain.Entidades.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Interfaces.RegisterUser
{
    public interface IRegisterUserDAL
    {
        Task<ResponseCreateETL> Register(UserETL user);
    }
}
